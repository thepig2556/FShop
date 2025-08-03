import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // For formatting timestamp
import 'favorite_provider.dart';
import 'product.dart';

class ProductDetailPage extends StatefulWidget {
  final int id;
  final String name;
  final double rate;
  final String price;
  final int priceNumber;
  final String image;
  final String description;

  const ProductDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.rate,
    required this.price,
    required this.priceNumber,
    required this.image,
    required this.description,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isFavorite = false;
  int quantity = 1;
  List<Map<String, dynamic>> comments = [];
  int _selectedRating = 1;
  final TextEditingController _commentController = TextEditingController();
  double _currentRate = 0;
  bool _isLoadingComments = false;
  bool _isSubmittingComment = false;
  bool _canComment = false;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  int get basePrice {
    final parsedPrice = int.tryParse(widget.price.replaceAll('đ', '').trim());
    return parsedPrice ?? widget.priceNumber.toInt();
  }

  int get totalPrice {
    return basePrice * quantity;
  }

  String formatPrice(int price) {
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  void _increaseQuantity() {
    if (quantity < 50) {
      setState(() {
        quantity++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số lượng tối đa là 50')),
      );
    }
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _toggleFavorite() {
    final product = Product(
      id: widget.id,
      name: widget.name,
      image: widget.image,
      rate: _currentRate != 0 ? _currentRate : widget.rate,
      description: widget.description,
      price: basePrice,
    );

    final favoriteProvider = context.read<FavoriteProvider>();
    favoriteProvider.toggleFavorite(product);

    setState(() {
      isFavorite = favoriteProvider.isFavorite(product);
    });
  }

  Future<void> _checkCanComment() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await _database
          .child('MobileNangCao/Bills/$userId')
          .get()
          .timeout(const Duration(seconds: 10));

      if (snapshot.exists) {
        final bills = Map<String, dynamic>.from(snapshot.value as Map);
        bool canComment = false;

        for (var bill in bills.values) {
          final billData = Map<String, dynamic>.from(bill);
          if (billData['statusID'] == 1) {
            final menuFood = billData['MenuFood'];
            if (menuFood is List) {
              for (var item in menuFood) {
                if (item != null && item['id'] == widget.id.toString()) {
                  canComment = true;
                  break;
                }
              }
            } else if (menuFood is Map) {
              for (var item in menuFood.values) {
                if (item['id'] == widget.id.toString()) {
                  canComment = true;
                  break;
                }
              }
            }
            if (canComment) break;
          }
        }

        setState(() {
          _canComment = canComment;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi kiểm tra đơn hàng: ${e.toString()}')),
      );
    }
  }

  Future<void> _fetchComments() async {
    setState(() {
      _isLoadingComments = true;
    });

    try {
      final commentsSnapshot = await _database
          .child('MobileNangCao/Comments/${widget.id}')
          .get()
          .timeout(const Duration(seconds: 10));

      final List<Map<String, dynamic>> loadedComments = [];
      if (commentsSnapshot.exists) {
        final commentsData = Map<String, dynamic>.from(commentsSnapshot.value as Map);
        for (var userId in commentsData.keys) {
          final userSnapshot = await _database
              .child('MobileNangCao/Users/$userId')
              .get()
              .timeout(const Duration(seconds: 5));

          String userName = 'Người dùng';
          String userAvatar = 'https://firebasestorage.googleapis.com/v0/b/tousehao.appspot.com/o/avt.png?alt=media&token=d4b325e8-c4f1-49e3-8438-3f980dd4a4bf';

          if (userSnapshot.exists) {
            final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
            userName = userData['name'] as String? ?? 'Người dùng';
            userAvatar = userData['avatar'] as String? ?? userAvatar;
          }

          final commentData = Map<String, dynamic>.from(commentsData[userId]);
          loadedComments.add({
            'userId': userId,
            'rate': commentData['rate'] as num,
            'content': commentData['content'] as String? ?? '',
            'userName': userName,
            'userAvatar': userAvatar,
            'timestamp': commentData['timestamp'] as int? ?? 0,
          });
        }
        loadedComments.sort((a, b) => b['rate'].compareTo(a['rate']));
      }

      setState(() {
        comments = loadedComments;
        _isLoadingComments = false;
      });
      await _updateFoodRating();
    } catch (e) {
      setState(() {
        _isLoadingComments = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lấy đánh giá: ${e.toString()}')),
      );
    }
  }

  Future<void> _addComment() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để đánh giá')),
      );
      return;
    }

    if (!_canComment) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bạn cần đặt hàng món này trước khi đánh giá')),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung đánh giá')),
      );
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      await _database
          .child('MobileNangCao/Comments/${widget.id}/$userId')
          .set({
        'rate': _selectedRating,
        'content': _commentController.text.trim(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }).timeout(const Duration(seconds: 10));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đánh giá đã được thêm'),
          backgroundColor: Colors.green,
        ),
      );
      _commentController.clear();
      setState(() {
        _isSubmittingComment = false;
      });
      await _fetchComments();
    } catch (e) {
      setState(() {
        _isSubmittingComment = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm đánh giá: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateFoodRating() async {
    if (comments.isEmpty) {
      setState(() {
        _currentRate = 0;
      });
      return;
    }

    final averageRating =
        comments.map((c) => c['rate'] as num).reduce((a, b) => a + b) /
            comments.length;
    try {
      await _database
          .child('MobileNangCao/Foods/${widget.id}')
          .update({'rate': averageRating}).timeout(const Duration(seconds: 10));
      setState(() {
        _currentRate = averageRating;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật đánh giá: ${e.toString()}')),
      );
    }
  }

  Future<void> _addToCart() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để thêm vào giỏ hàng')),
      );
      return;
    }

    if (quantity > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số lượng tối đa là 50')),
      );
      return;
    }

    try {
      await _database
          .child('MobileNangCao/Cart/$userId/MenuFood/${widget.id}')
          .set({'quantity': quantity, 'id': widget.id.toString()}).timeout(const Duration(seconds: 10));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm ${widget.name} (x$quantity) vào giỏ hàng'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm vào giỏ hàng: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final favoriteProvider = context.read<FavoriteProvider>();
    final product = Product(
      id: widget.id,
      name: widget.name,
      image: widget.image,
      rate: widget.rate,
      description: widget.description,
      price: basePrice,
    );
    setState(() {
      isFavorite = favoriteProvider.isFavorite(product);
      _currentRate = widget.rate;
    });
    _fetchComments();
    _checkCanComment();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showCommentDialog() {
    int dialogRating = _selectedRating;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Danh sách đánh giá'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_canComment) ...[
                      const Text('Thêm đánh giá của bạn:'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                dialogRating = index + 1;
                              });
                              setState(() {
                                _selectedRating = dialogRating;
                              });
                            },
                            child: Icon(
                              index < dialogRating ? Icons.star : Icons.star_border,
                              color: Colors.orange,
                              size: 30,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          labelText: 'Nội dung đánh giá',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                    ],
                    const Text('Tất cả đánh giá:'),
                    const SizedBox(height: 8),
                    Expanded(
                      child: comments.isEmpty
                          ? const Text(
                        'Chưa có đánh giá nào.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: comment['userAvatar'].isNotEmpty
                                    ? NetworkImage(comment['userAvatar'])
                                    : const AssetImage('assets/images/default_avatar.png')
                                as ImageProvider,
                                radius: 20,
                              ),
                              title: Text(
                                comment['userName'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Icon(
                                        i < comment['rate']
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.orange,
                                        size: 16,
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(comment['content']),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTimestamp(comment['timestamp']),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (_canComment)
                  ElevatedButton(
                    onPressed: _isSubmittingComment
                        ? null
                        : () {
                      _addComment();
                      Navigator.pop(context);
                    },
                    child: _isSubmittingComment
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Gửi'),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF5C7C99),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: widget.image.startsWith('http')
                            ? NetworkImage(widget.image)
                            : AssetImage('assets/images/${widget.image}')
                        as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: _toggleFavorite,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E4057),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index <
                                      (_currentRate != 0
                                          ? _currentRate.floor()
                                          : widget.rate.floor())
                                      ? Icons.star
                                      : (index <
                                      (_currentRate != 0
                                          ? _currentRate
                                          : widget.rate)
                                      ? Icons.star_half
                                      : Icons.star_border),
                                  color: Colors.orange,
                                  size: 30,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(_currentRate != 0 ? _currentRate : widget.rate).toStringAsFixed(1)} (${comments.length} đánh giá)',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatPrice(basePrice),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: _decreaseQuantity,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: quantity > 1
                                            ? Colors.red[50]
                                            : Colors.grey[100],
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color:
                                        quantity > 1 ? Colors.red : Colors.grey,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _increaseQuantity,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.blue,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E4057),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Đánh giá',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E4057),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _isLoadingComments
                            ? const Center(child: CircularProgressIndicator())
                            : comments.isEmpty
                            ? const Text(
                          'Chưa có đánh giá nào.',
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey),
                        )
                            : Column(
                          children: comments.take(3).map((comment) {
                            return Card(
                              margin:
                              const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                  comment['userAvatar'].isNotEmpty
                                      ? NetworkImage(
                                      comment['userAvatar'])
                                      : const AssetImage(
                                      'assets/images/default_avatar.png')
                                  as ImageProvider,
                                  radius: 20,
                                ),
                                title: Text(
                                  comment['userName'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < comment['rate']
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.orange,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(comment['content']),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatTimestamp(
                                          comment['timestamp']),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _showCommentDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C7C99),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          child: const Text(
                            'Hiển thị thêm bình luận',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng tiền',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          formatPrice(totalPrice),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C7C99),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart, size: 25),
                          const SizedBox(width: 8),
                          Text(
                            'Thêm vào giỏ ($quantity)',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}