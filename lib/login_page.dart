import 'package:doan/main.dart';
import 'package:flutter/material.dart';
import 'package:doan/login_form_page.dart' as loginForm;
import 'package:doan/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF6284AF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildInfoCard(context),
              SizedBox(height: screenHeight * 0.01),
              _buildWelcomeText(context),
              SizedBox(height: screenHeight * 0.02),
              _buildLoginBtn(context),
              SizedBox(height: screenHeight * 0.03),
              _buildRegisterBtn(context),
              SizedBox(height: screenHeight * 0.03),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: const Divider(
                  color: Color(0xFFE8E8E8),
                  thickness: 1,
                  height: 1,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'Phiên bản 1.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFB8C5D1),
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

  Widget _buildInfoCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(screenWidth * 0.06),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PizzaLogo(),
              SizedBox(width: screenWidth * 0.04),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Pizza ',
                            style: TextStyle(
                              color: Color(0xFF1B5E20),
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'MART',
                            style: TextStyle(
                              color: Color(0xFF2E4057),
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
                        color: Color(0xFF5D6D7E),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.02),
          _buildFeatureItem(
            icon: Icons.restaurant_menu,
            iconColor: const Color(0xFFD84315),
            text: 'Thực phẩm nguyên chất',
          ),
          _buildFeatureItem(
            icon: Icons.local_shipping,
            iconColor: const Color(0xFF1565C0),
            text: 'Giao hàng nhanh',
          ),
          _buildFeatureItem(
            icon: Icons.attach_money,
            iconColor: const Color(0xFF2E7D32),
            text: 'Đảm bảo hoàn tiền',
          ),
          _buildFeatureItem(
            icon: Icons.security,
            iconColor: const Color(0xFFC62828),
            text: 'An toàn và bảo mật',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const Text(
          'Chào mừng đến với',
          style: TextStyle(
            color: Color(0xFFF8F9FA),
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const Text(
          'cửa hàng của chúng tôi',
          style: TextStyle(
            color: Color(0xFFF8F9FA),
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: screenWidth * 0.01),
        const Text(
          'Nhận hàng tạp hóa của bạn nhanh nhất\nchỉ trong một giờ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFD5DBDB),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
          softWrap: true,
        ),
      ],
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B5E20),
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
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF8F9FA),
          foregroundColor: const Color(0xFF1B5E20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xFF1B5E20),
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
                color: Color(0xFF2E4057),
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.25,
      height: screenWidth * 0.25,
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
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}