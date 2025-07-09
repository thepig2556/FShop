import 'package:doan/main.dart';
import 'package:flutter/material.dart';
import 'package:doan/login_form_page.dart' as loginForm; // Import LoginFormPage

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6CC04A),
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
              _buildGoogleBtn(context),
              const SizedBox(height: 12),
              _buildFacebookBtn(context),
              const SizedBox(height: 12),
              _buildLoginBtn(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PizzaLogo(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Pizza ',
                          style: TextStyle(
                            color: Color(0xFF6CC04A),
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'MART',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Giao đồ ăn',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFeatureItem(
              icon: Icons.restaurant_menu,
              iconColor: Colors.orange,
              text: 'Thực phẩm nguyên chất'),
          _buildFeatureItem(
              icon: Icons.local_shipping,
              iconColor: Colors.blue,
              text: 'Giao hàng nhanh'),
          _buildFeatureItem(
              icon: Icons.attach_money,
              iconColor: Colors.green,
              text: 'Đảm bảo hoàn tiền'),
          _buildFeatureItem(
              icon: Icons.security,
              iconColor: Colors.red,
              text: 'An toàn và bảo mật'),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() => Column(
    children: const [
      Text('Chào mừng đến với',
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500)),
      Text('cửa hàng của chúng tôi',
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500)),
      SizedBox(height: 5),
      Text(
        'Nhận hàng tạp hóa của bạn nhanh nhất\nchỉ trong một giờ',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 20),
      ),
    ],
  );

  Widget _buildGoogleBtn(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onPressed: () => _navToMain(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIconBox('G', Colors.red),
            const SizedBox(width: 12),
            const Text('Tiếp tục với Google',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFacebookBtn(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4267B2),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _navToMain(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIconBox('f', const Color(0xFF4267B2)),
            const SizedBox(width: 12),
            const Text('Tiếp tục với Facebook',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF6CC04A),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF6CC04A))),
        ),
        onPressed: () => _navToLogin(context),
        child: const Text('Đăng nhập',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildFeatureItem(
      {required IconData icon,
        required Color iconColor,
        required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 35),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _socialIconBox(String char, Color color) => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(4)),
    child: Center(
      child: Text(char,
          style:
          TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
    ),
  );

  void _navToLogin(BuildContext context) =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const loginForm.LoginFormPage()));

  void _navToMain(BuildContext context) =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
}

class _PizzaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        'assets/images/logo.png', // Đường dẫn đến file logo.png
        fit: BoxFit.cover, // Đảm bảo hình ảnh lấp đầy container
      ),
    );
  }
}