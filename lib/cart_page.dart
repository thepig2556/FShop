import 'package:flutter/material.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar cố định (không có nút quay lại)
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
                    color: const Color(0xFF6284AF).withOpacity(0.3),
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

            // Nội dung cuộn
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/images/pizza2.png',
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text("Pizza Dăm Bông Bắp",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        Text("Pizza", style: TextStyle(color: Color(0xFF64748B))),
                                        Text("12inch/305,000đ", style: TextStyle(color: Color(0xFF94A3B8))),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _QuantityButton(
                                        icon: Icons.remove,
                                        onPressed: () {
                                          print('Giảm số lượng');
                                        },
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text("2",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 16)),
                                      ),
                                      _QuantityButton(
                                        icon: Icons.add,
                                        onPressed: () {
                                          print('Tăng số lượng');
                                        },
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      print('Xóa sản phẩm');
                                    },
                                    icon: const Icon(Icons.close,
                                        color: Color(0xFFE74C3C), size: 24),
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

            // Thanh toán
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6284AF),
                    Color(0xFF8BA3C7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6284AF).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Thanh toán\n1.850.000đ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF77C29F),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text("Thanh toán", style: TextStyle(fontSize: 16)),
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
        border: Border.all(color: const Color(0xFF6284AF).withOpacity(0.3), width: 1),
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
