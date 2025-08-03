import 'package:doan/home_page.dart';
import 'package:doan/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum PaymentMethod { cod, card }

class CheckoutPage extends StatefulWidget {
  final List<dynamic> cartItems;
  final double totalPrice;

  const CheckoutPage({super.key, required this.cartItems, required this.totalPrice});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod _selectedMethod = PaymentMethod.cod;
  final Color primaryColor = const Color(0xFF6284AF);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _showSnackBar('Vui lòng đăng nhập để tiếp tục');
      setState(() => isLoading = false);
      return;
    }

    final database = FirebaseDatabase.instance.ref();
    try {
      final userSnapshot = await database.child('MobileNangCao/Users/$userId').get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.value as Map<dynamic, dynamic>;
        _nameController.text = userData['name'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _addressController.text = userData['address'] ?? '';
      }
      setState(() => isLoading = false);
    } catch (e) {
      _showSnackBar('Lỗi khi lấy thông tin người dùng: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _placeOrder() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _showSnackBar('Vui lòng đăng nhập để đặt hàng');
      return;
    }

    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      _showSnackBar('Vui lòng điền đầy đủ thông tin người nhận');
      return;
    }

    final database = FirebaseDatabase.instance.ref();
    final billId = const Uuid().v4();
    final createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final deliveryFee = 20000.0;
    final totalWithFee = widget.totalPrice + deliveryFee;

    try {
      final menuFood = {
        for (var item in widget.cartItems)
          item['foodId']: {'id': item['foodId'], 'quantity': item['quantity']}
      };

      await database.child('MobileNangCao/Bills/$userId/$billId').set({
        'billID': billId,
        'MenuFood': menuFood,
        'createdAt': createdAt,
        'statusID': 2,
        'total': totalWithFee,
        'userID': userId,
      });

      await database.child('MobileNangCao/Cart/$userId').remove();

      _showSuccessDialog();
    } catch (e) {
      _showSnackBar('Lỗi khi đặt hàng: $e');
    }
  }

  void _showSuccessDialog() {
    String methodName = _selectedMethod == PaymentMethod.cod
        ? "Thanh toán khi nhận hàng"
        : "Thẻ ngân hàng / Ví điện tử";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: const [
            Icon(Icons.check_circle, color: Color(0xFF6284AF), size: 60),
            SizedBox(height: 12),
            Text(
              "Đặt hàng thành công!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "Phương thức thanh toán: $methodName",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MainScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6284AF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Quay về", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatPrice(double price) {
    return '${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }

  @override
  Widget build(BuildContext context) {
    const deliveryFee = 20000.0;
    final totalWithFee = widget.totalPrice + deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // AppBar
            Container(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Đặt hàng',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _SectionTitle(title: "Thông tin người nhận", color: primaryColor),
                    _InputBox(icon: Icons.person, hint: "Tên người nhận", controller: _nameController),
                    _InputBox(icon: Icons.phone, hint: "Số điện thoại", controller: _phoneController),
                    _InputBox(icon: Icons.location_on, hint: "Địa chỉ giao hàng", controller: _addressController),

                    const SizedBox(height: 16),
                    _SectionTitle(title: "Phương thức thanh toán", color: primaryColor),
                    _PaymentTile(
                      title: "Thanh toán khi nhận hàng (COD)",
                      value: PaymentMethod.cod,
                      groupValue: _selectedMethod,
                      onChanged: (value) => setState(() => _selectedMethod = value!),
                      primaryColor: primaryColor,
                    ),
                    _PaymentTile(
                      title: "Thẻ ngân hàng / Ví điện tử",
                      value: PaymentMethod.card,
                      groupValue: _selectedMethod,
                      onChanged: null,
                      primaryColor: primaryColor,
                    ),

                    const SizedBox(height: 16),
                    _SectionTitle(title: "Hóa đơn", color: primaryColor),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _InvoiceRow(label: "Tạm tính", value: _formatPrice(widget.totalPrice)),
                            const _InvoiceRow(label: "Phí giao hàng", value: "20.000đ"),
                            const _InvoiceRow(label: "Giảm giá", value: "0đ"),
                            const Divider(),
                            _InvoiceRow(
                              label: "Tổng thanh toán",
                              value: _formatPrice(totalWithFee),
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Đặt hàng",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;

  const _InputBox({required this.icon, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF6284AF)),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _InvoiceRow({required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String title;
  final PaymentMethod value;
  final PaymentMethod groupValue;
  final ValueChanged<PaymentMethod?>? onChanged;
  final Color primaryColor;

  const _PaymentTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: value == groupValue ? primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: RadioListTile<PaymentMethod>(
          value: value,
          groupValue: groupValue,
          activeColor: primaryColor,
          title: Text(
            title,
            style: TextStyle(
              color: onChanged == null ? Colors.grey : Colors.black,
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}