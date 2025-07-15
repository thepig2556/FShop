import 'package:doan/main.dart';
import 'package:flutter/material.dart';
import 'package:doan/login_form_page.dart' as loginForm;
import 'package:doan/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6284AF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 0),
              _buildInfoCard(),
              const SizedBox(height: 5),
              _buildWelcomeText(),
              const SizedBox(height: 10),
              _buildLoginBtn(context),
              const SizedBox(height: 15),
              _buildRegisterBtn(context),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(
                  color: Color(0xFFE8E8E8), // Màu xám nhẹ
                  thickness: 1,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Phiên bản 1.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFB8C5D1), // Màu xám xanh nhẹ
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // Màu trắng kem, dễ nhìn
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PizzaLogo(),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Pizza ',
                          style: TextStyle(
                            color: Color(0xFF1B5E20), // Màu xanh lá đậm, dễ đọc
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'MART',
                          style: TextStyle(
                            color: Color(0xFF2E4057), // Màu xanh navy
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Giao đồ ăn',
                    style: TextStyle(
                      color: Color(0xFF5D6D7E), // Màu xám xanh
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildFeatureItem(
            icon: Icons.restaurant_menu,
            iconColor: const Color(0xFFD84315), // Màu cam đậm
            text: 'Thực phẩm nguyên chất',
          ),
          _buildFeatureItem(
            icon: Icons.local_shipping,
            iconColor: const Color(0xFF1565C0), // Màu xanh dương đậm
            text: 'Giao hàng nhanh',
          ),
          _buildFeatureItem(
            icon: Icons.attach_money,
            iconColor: const Color(0xFF2E7D32), // Màu xanh lá đậm
            text: 'Đảm bảo hoàn tiền',
          ),
          _buildFeatureItem(
            icon: Icons.security,
            iconColor: const Color(0xFFC62828), // Màu đỏ đậm
            text: 'An toàn và bảo mật',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() => Column(
    children: const [
      Text(
        'Chào mừng đến với',
        style: TextStyle(
          color: Color(0xFFF8F9FA), // Màu trắng kem
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        'cửa hàng của chúng tôi',
        style: TextStyle(
          color: Color(0xFFF8F9FA), // Màu trắng kem
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 5),
      Text(
        'Nhận hàng tạp hóa của bạn nhanh nhất\nchỉ trong một giờ',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFD5DBDB), // Màu xám nhẹ
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
    ],
  );

  Widget _buildLoginBtn(BuildContext context) {
    return SizedBox(
      height: 56, // Tăng chiều cao cho dễ bấm
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B5E20), // Màu xanh lá đậm
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        onPressed: () => _navToLogin(context),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterBtn(BuildContext context) {
    return SizedBox(
      height: 56, // Tăng chiều cao cho dễ bấm
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF8F9FA), // Màu trắng kem
          foregroundColor: const Color(0xFF1B5E20), // Màu xanh lá đậm
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xFF1B5E20), // Viền xanh lá đậm
              width: 2,
            ),
          ),
          elevation: 2,
        ),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RegisterPage()),
        ),
        child: const Text(
          'Đăng ký',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF2E4057), // Màu xanh navy
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navToLogin(BuildContext context) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const loginForm.LoginFormPage()),
  );
}

class _PizzaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.cover,
      ),
    );
  }
}