import 'package:flutter/material.dart';

enum PaymentMethod {
  cod,
  card,
  bankTransfer,
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod _selectedMethod = PaymentMethod.cod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6ED),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AppBar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF77C29F),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Thanh toán',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Thông tin người nhận
              _SectionTitle(title: "Thông tin người nhận"),
              _InputBox(icon: Icons.person, hint: "Tên người nhận"),
              _InputBox(icon: Icons.phone, hint: "Số điện thoại"),
              _InputBox(icon: Icons.location_on, hint: "Địa chỉ giao hàng"),

              const SizedBox(height: 16),

              // Phương thức thanh toán
              _SectionTitle(title: "Phương thức thanh toán"),
              RadioListTile<PaymentMethod>(
                value: PaymentMethod.cod,
                groupValue: _selectedMethod,
                activeColor: Colors.green,
                title: const Text("Thanh toán khi nhận hàng (COD)"),
                onChanged: (value) => setState(() => _selectedMethod = value!),
              ),
              RadioListTile<PaymentMethod>(
                value: PaymentMethod.card,
                groupValue: _selectedMethod,
                activeColor: Colors.green,
                title: const Text("Thẻ ngân hàng / Ví điện tử"),
                onChanged: (value) => setState(() => _selectedMethod = value!),
              ),

              const SizedBox(height: 16),

              // Tổng kết hóa đơn
              _SectionTitle(title: "Hóa đơn"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              const SizedBox(height: 24),

              // Nút đặt hàng
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    String methodName;
                    switch (_selectedMethod) {
                      case PaymentMethod.cod:
                        methodName = "Thanh toán khi nhận hàng";
                        break;
                      case PaymentMethod.card:
                        methodName = "Thẻ ngân hàng / Ví điện tử";
                        break;
                      case PaymentMethod.bankTransfer:
                        methodName = "Chuyển khoản";
                        break;
                    }

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Đặt hàng thành công!"),
                        content: Text("Phương thức thanh toán: $methodName"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF77C29F),
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

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Các widget phụ

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.green),
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
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
