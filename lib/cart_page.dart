import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];
  bool isLoading = true;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _showSnackBar('Vui lòng đăng nhập để xem giỏ hàng');
      setState(() => isLoading = false);
      return;
    }

    final database = FirebaseDatabase.instance.ref();
    try {
      await _cleanInvalidCartItems(userId);
      final cartSnapshot =
          await database.child('MobileNangCao/Cart/$userId').get();
      if (!cartSnapshot.exists) {
        setState(() {
          cartItems = [];
          totalPrice = 0;
          isLoading = false;
        });
        return;
      }

      final cartData = cartSnapshot.value as Map<dynamic, dynamic>? ?? {};
      final menuFood = cartData['MenuFood'];
      List<dynamic> menuFoodItems =
          menuFood is Map
              ? menuFood.entries.map((e) => e.value).toList()
              : menuFood is List
              ? menuFood
              : [];

      if (menuFoodItems.isEmpty) {
        setState(() {
          cartItems = [];
          totalPrice = 0;
          isLoading = false;
        });
        return;
      }

      final foodsSnapshot = await database.child('MobileNangCao/Foods').get();
      final foodsList =
          foodsSnapshot.exists
              ? foodsSnapshot.value as List<dynamic>? ?? []
              : [];

      final enrichedItems =
          menuFoodItems
              .where(
                (item) =>
                    item != null &&
                    item['id'] != null &&
                    item['quantity'] != null,
              )
              .map((item) {
                final foodId = item['id'].toString();
                final quantity = item['quantity'] as int;
                final foodData = foodsList.firstWhere(
                  (food) => food != null && food['id']?.toString() == foodId,
                  orElse: () => null,
                );

                if (foodData == null) {
                  return {
                    'foodId': foodId,
                    'quantity': quantity,
                    'name': 'Món không tồn tại',
                    'image': '',
                    'price': 0.0,
                  };
                }

                return {
                  'foodId': foodId,
                  'quantity': quantity,
                  'name': foodData['name'] ?? 'Không xác định',
                  'image': foodData['image'] ?? '',
                  'price': (foodData['price'] as num?)?.toDouble() ?? 0.0,
                };
              })
              .toList();

      setState(() {
        cartItems = enrichedItems;
        totalPrice = (cartData['total'] as num?)?.toDouble() ?? 0.0;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateCartTotal(String userId) async {
    final database = FirebaseDatabase.instance.ref();
    try {
      final cartSnapshot =
          await database.child('MobileNangCao/Cart/$userId').get();
      if (!cartSnapshot.exists) {
        await database.child('MobileNangCao/Cart/$userId/total').set(0);
        setState(() => totalPrice = 0);
        return;
      }

      final cartData = cartSnapshot.value as Map<dynamic, dynamic>? ?? {};
      final menuFood = cartData['MenuFood'];
      List<dynamic> menuFoodItems =
          menuFood is Map
              ? menuFood.entries.map((e) => e.value).toList()
              : menuFood is List
              ? menuFood
              : [];

      if (menuFoodItems.isEmpty) {
        await database.child('MobileNangCao/Cart/$userId/total').set(0);
        setState(() => totalPrice = 0);
        return;
      }

      final foodsSnapshot = await database.child('MobileNangCao/Foods').get();
      final foodsList =
          foodsSnapshot.exists
              ? (foodsSnapshot.value as List<dynamic>? ?? [])
              : [];

      double total = 0;
      for (var item in menuFoodItems) {
        if (item == null || item['id'] == null || item['quantity'] == null) {
          continue;
        }
        final foodId = item['id'].toString();
        final quantity = item['quantity'] as int;

        final foodData = foodsList.firstWhere(
          (food) => food != null && food['id']?.toString() == foodId,
          orElse: () => null,
        );

        if (foodData == null) {
          continue;
        }

        final price = (foodData['price'] as num?)?.toDouble();
        if (price == null) {
          continue;
        }

        total += price * quantity;
      }

      await database.child('MobileNangCao/Cart/$userId/total').set(total);
      setState(() => totalPrice = total);
    } catch (e, stackTrace) {}
  }

  Future<void> _cleanInvalidCartItems(String userId) async {
    final database = FirebaseDatabase.instance.ref();
    try {
      final cartSnapshot =
          await database.child('MobileNangCao/Cart/$userId').get();
      if (!cartSnapshot.exists) return;

      final cartData = cartSnapshot.value as Map<dynamic, dynamic>? ?? {};
      final menuFood = cartData['MenuFood'];
      if (menuFood == null) return;

      final foodsSnapshot = await database.child('MobileNangCao/Foods').get();
      final foodsList =
          foodsSnapshot.exists
              ? (foodsSnapshot.value as List<dynamic>? ?? [])
              : [];
      final validFoodIds =
          foodsList
              .where((food) => food != null)
              .map((food) => food['id'].toString())
              .toSet();

      if (menuFood is Map) {
        for (var entry in menuFood.entries) {
          final foodId = entry.value['id']?.toString();
          if (foodId != null && !validFoodIds.contains(foodId)) {
            print('Removing invalid item with foodId: $foodId');
            await database
                .child('MobileNangCao/Cart/$userId/MenuFood/${entry.key}')
                .remove();
          }
        }
      }
      await _updateCartTotal(userId);
    } catch (e) {}
  }

  Future<void> _updateQuantity(String foodId, int quantity) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return;
    }

    if (quantity > 50) {
      return;
    }

    final database = FirebaseDatabase.instance.ref();
    try {
      await database
          .child('MobileNangCao/Cart/$userId/MenuFood/$foodId')
          .update({'id': foodId, 'quantity': quantity});
      await _updateCartTotal(userId);
      await _fetchCartItems();
    } catch (e) {}
  }

  Future<void> _removeItem(String foodId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return;
    }

    final database = FirebaseDatabase.instance.ref();
    try {
      await database
          .child('MobileNangCao/Cart/$userId/MenuFood/$foodId')
          .remove();
      await _updateCartTotal(userId);
      await _fetchCartItems();
    } catch (e) {}
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String formatPrice(double price) {
    return '${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }

  void reload() {
    setState(() {
      isLoading = true;
      cartItems = [];
      totalPrice = 0;
    });
    _fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6284AF),
                    Color(0xFF8BA3C7),
                    Color(0xFFB8C5D6),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6284AF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Giỏ hàng',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : cartItems.isEmpty
                      ? const Center(child: Text('Giỏ hàng trống'))
                      : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = cartItems[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.network(
                                              item['image'] ?? '',
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Image.asset(
                                                    'assets/images/pizza2.png',
                                                    width: 90,
                                                    height: 90,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['name'] ??
                                                      'Không xác định',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const Text(
                                                  'Món ăn',
                                                  style: TextStyle(
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                                Text(
                                                  '${item['quantity']} x ${formatPrice(item['price'] ?? 0)}',
                                                  style: const TextStyle(
                                                    color: Color(0xFF94A3B8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              _QuantityButton(
                                                icon: Icons.remove,
                                                onPressed: () {
                                                  if (item['quantity'] > 1) {
                                                    _updateQuantity(
                                                      item['foodId'],
                                                      item['quantity'] - 1,
                                                    );
                                                  }
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                    ),
                                                child: Text(
                                                  item['quantity'].toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              _QuantityButton(
                                                icon: Icons.add,
                                                onPressed: () {
                                                  _updateQuantity(
                                                    item['foodId'],
                                                    item['quantity'] + 1,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed:
                                                () =>
                                                    _removeItem(item['foodId']),
                                            icon: const Icon(
                                              Icons.close,
                                              color: Color(0xFFE74C3C),
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6284AF), Color(0xFF8BA3C7)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6284AF).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Thanh toán\n${formatPrice(totalPrice)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        cartItems.isEmpty
                            ? null
                            : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CheckoutPage(
                                      cartItems: cartItems,
                                      totalPrice: totalPrice,
                                    ),
                              ),
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF77C29F),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Thanh toán',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF6284AF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF6284AF).withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF6284AF), size: 18),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}
