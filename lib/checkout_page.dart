import 'package:flutter/material.dart';

enum PaymentMethod { cod, card }

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod _selectedMethod = PaymentMethod.cod;

  final Color primaryColor = const Color(0xFF6284AF); // Màu chủ đạo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
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
                    onPressed: () => Navigator.pop(context), // QUAY LẠI TRANG TRƯỚC
                  ),
                  const Spacer(),
                  const Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(), // Giúp tiêu đề căn giữa
                  const SizedBox(width: 48), // Để cân đối với IconButton bên trái
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
                    const _InputBox(icon: Icons.person, hint: "Tên người nhận"),
                    const _InputBox(icon: Icons.phone, hint: "Số điện thoại"),
                    const _InputBox(icon: Icons.location_on, hint: "Địa chỉ giao hàng"),

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
                      onChanged: (value) => setState(() => _selectedMethod = value!),
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
                          children: const [
                            _InvoiceRow(label: "Tạm tính", value: "1.830.000đ"),
                            _InvoiceRow(label: "Phí giao hàng", value: "20.000đ"),
                            _InvoiceRow(label: "Giảm giá", value: "0đ"),
                            Divider(),
                            _InvoiceRow(label: "Tổng thanh toán", value: "1.850.000đ", isTotal: true),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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

  void _placeOrder() {
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
              Navigator.pop(context); // Đóng dialog
              Navigator.pop(context); // Quay lại trang trước nếu cần
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6284AF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Quay về", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );

  }
}

// ==== COMPONENTS ====

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
        child: Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final IconData icon;
  final String hint;
  const _InputBox({required this.icon, required this.hint});

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
        decoration: InputDecoration(
          icon: Icon(icon, color: Color(0xFF6284AF)),
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
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 16 : 14)),
          Text(value,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 16 : 14)),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String title;
  final PaymentMethod value;
  final PaymentMethod groupValue;
  final ValueChanged<PaymentMethod?> onChanged;
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
          title: Text(title),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
