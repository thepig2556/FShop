import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<Map<dynamic, dynamic>> orders = [];
  bool isLoading = true;
  String? errorMessage;
  final database = FirebaseDatabase.instance.ref();
  final List<String> statusLabels = ["Hủy/Từ chối", "Giao hàng thành công", "Đang giao hàng"];
  int selectedStatus = -1;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    if (userId.isEmpty) {
      setState(() {
        errorMessage = 'Vui lòng đăng nhập để xem đơn hàng';
        isLoading = false;
      });
      return;
    }

    try {
      final snapshot = await database.child('MobileNangCao/Bills/$userId').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          orders = data.entries.map((entry) {
            final order = entry.value as Map<dynamic, dynamic>;
            return {...order, 'billID': entry.key};
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Không có đơn hàng nào';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Lỗi khi lấy danh sách đơn hàng: $e';
      });
    }
  }

  List<Map<dynamic, dynamic>> _filterOrdersByStatus(int statusId) {
    if (selectedStatus == -1) return orders;
    return orders.where((order) => order['statusID'] == statusId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Đơn hàng của tôi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF6284AF),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6284AF)),
          strokeWidth: 3,
        ),
      )
          : errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lọc theo trạng thái',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatusButton(2, 'Đang giao', Icons.local_shipping),
                      const SizedBox(width: 8),
                      _buildStatusButton(0, 'Đã hủy', Icons.cancel_outlined),
                      const SizedBox(width: 8),
                      _buildStatusButton(1, 'Hoàn thành', Icons.check_circle_outline),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filterOrdersByStatus(selectedStatus).isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không có đơn hàng phù hợp',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filterOrdersByStatus(selectedStatus).length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = _filterOrdersByStatus(selectedStatus)[index];
                return _buildOrderCard(order);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(int statusId, String label, IconData icon) {
    final isSelected = selectedStatus == statusId;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = isSelected ? -1 : statusId;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6284AF) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6284AF) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF6284AF),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF6284AF),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<dynamic, dynamic> order) {
    final billId = order['billID'];
    final createdAt = order['createdAt'];
    final total = order['total'];
    final statusId = order['statusID'];

    Color statusColor;
    IconData statusIcon;

    switch (statusId) {
      case 0:
        statusColor = Colors.red[600]!;
        statusIcon = Icons.cancel;
        break;
      case 1:
        statusColor = Colors.green[600]!;
        statusIcon = Icons.check_circle;
        break;
      case 2:
        statusColor = Colors.orange[600]!;
        statusIcon = Icons.local_shipping;
        break;
      default:
        statusColor = Colors.grey[600]!;
        statusIcon = Icons.help_outline;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailPage(
                billId: billId,
                onStatusUpdated: _fetchOrders,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Đơn hàng #${billId.toString().substring(0, billId.length > 8 ? 8 : billId.length)}...',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusLabels[statusId],
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ngày đặt: $createdAt',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.payments_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Tổng tiền: ',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(total),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF6284AF),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      color: const Color(0xFF6284AF),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFF6284AF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailPage extends StatefulWidget {
  final String billId;
  final VoidCallback onStatusUpdated;

  const OrderDetailPage({super.key, required this.billId, required this.onStatusUpdated});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Map<dynamic, dynamic>? order;
  List<Map<dynamic, dynamic>> foods = [];
  bool isLoading = true;
  String? errorMessage;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final database = FirebaseDatabase.instance.ref();
  final List<String> statusLabels = ["Hủy/Từ chối", "Giao hàng thành công", "Đang giao hàng"];
  int? selectedStatus;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    if (userId.isEmpty) {
      setState(() {
        errorMessage = 'Vui lòng đăng nhập để xem chi tiết đơn hàng';
        isLoading = false;
      });
      return;
    }

    try {
      final orderSnapshot = await database.child('MobileNangCao/Bills/$userId/${widget.billId}').get();
      if (!orderSnapshot.exists) {
        setState(() {
          errorMessage = 'Không tìm thấy hóa đơn';
          isLoading = false;
        });
        return;
      }

      final orderData = orderSnapshot.value as Map<dynamic, dynamic>?;
      if (orderData == null) {
        setState(() {
          errorMessage = 'Dữ liệu hóa đơn không hợp lệ';
          isLoading = false;
        });
        return;
      }

      final menuFood = orderData['MenuFood'];
      if (menuFood == null) {
        setState(() {
          errorMessage = 'Không tìm thấy thông tin món ăn trong hóa đơn';
          isLoading = false;
        });
        return;
      }

      final foodSnapshot = await database.child('MobileNangCao/Foods').get();
      if (!foodSnapshot.exists || foodSnapshot.value == null) {
        setState(() {
          errorMessage = 'Không tìm thấy thông tin món ăn';
          isLoading = false;
        });
        return;
      }

      final foodData = foodSnapshot.value is List
          ? foodSnapshot.value as List<dynamic>
          : (foodSnapshot.value as Map<dynamic, dynamic>).values.toList();

      List<Map<dynamic, dynamic>> tempFoods = [];

      if (menuFood is List) {
        for (var item in menuFood) {
          // Skip null items
          if (item == null || item['id'] == null) continue;
          final foodId = item['id']?.toString();
          final quantity = item['quantity'];
          final food = foodData.firstWhere(
                (food) => food != null && food['id']?.toString() == foodId,
            orElse: () => null,
          );
          if (food != null) {
            tempFoods.add({
              ...food,
              'quantity': quantity,
            });
          }
        }
      } else if (menuFood is Map) {
        menuFood.forEach((foodId, details) {
          final food = foodData.firstWhere(
                (food) => food != null && food['id']?.toString() == foodId.toString(),
            orElse: () => null,
          );
          if (food != null) {
            tempFoods.add({
              ...food,
              'quantity': details['quantity'],
            });
          }
        });
      }

      setState(() {
        order = orderData;
        foods = tempFoods;
        selectedStatus = orderData['statusID'] as int?;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi khi lấy chi tiết đơn hàng: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _cancelOrder() async {
    if (order!['statusID'] != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Chỉ có thể hủy đơn hàng đang giao'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn hàng'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không', style: TextStyle(color: Color(0xFF6284AF))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Có', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await database.child('MobileNangCao/Bills/$userId/${widget.billId}/statusID').set(0);
      setState(() {
        selectedStatus = 0;
        order!['statusID'] = 0;
      });
      widget.onStatusUpdated();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Hủy đơn hàng thành công'),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi hủy đơn hàng: $e'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onStatusUpdated();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            'Chi tiết đơn hàng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF6284AF),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: selectedStatus == 2
            ? Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
          ),
          child: ElevatedButton(
            onPressed: _cancelOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              'Hủy đơn hàng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
            : null,
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6284AF)),
            strokeWidth: 3,
          ),
        )
            : errorMessage != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            : SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin đơn hàng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.receipt_long, 'Mã đơn hàng', widget.billId),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.access_time, 'Ngày đặt', order!['createdAt']),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.payments_outlined,
                      'Tổng tiền',
                      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(order!['total']),
                      isAmount: true,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(
                      'Trạng thái đơn hàng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          selectedStatus == 0
                              ? Icons.cancel
                              : selectedStatus == 1
                              ? Icons.check_circle
                              : Icons.local_shipping,
                          size: 20,
                          color: selectedStatus == 0
                              ? Colors.red[600]
                              : selectedStatus == 1
                              ? Colors.green[600]
                              : Colors.orange[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            statusLabels[selectedStatus!],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: selectedStatus == 0
                                  ? Colors.red[600]
                                  : selectedStatus == 1
                                  ? Colors.green[600]
                                  : Colors.orange[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh sách món ăn (${foods.length} món)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...foods.asMap().entries.map((entry) {
                      final index = entry.key;
                      final food = entry.value;
                      return Column(
                        children: [
                          _buildFoodItem(food),
                          if (index < foods.length - 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(height: 1),
                            ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isAmount = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: isAmount ? FontWeight.w600 : FontWeight.w500,
                  fontSize: isAmount ? 16 : 15,
                  color: isAmount ? const Color(0xFF6284AF) : Colors.grey[800],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItem(Map<dynamic, dynamic> food) {
    final name = food['name'] ?? 'Unknown';
    final price = food['price'] ?? 0;
    final quantity = food['quantity'] ?? 0;
    final image = food['image'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  color: Colors.grey[400],
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'x$quantity',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(price),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF6284AF),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}