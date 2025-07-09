import 'package:doan/forgot_pass_page.dart';
import 'package:doan/main.dart' as main; // Import MainScreen từ main.dart
import 'package:doan/register_page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class LoginFormPage extends StatelessWidget {
  const LoginFormPage({super.key});

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
              const SizedBox(height: 40),
              const Text(
                'Đăng nhập',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Đặt món dễ dàng\nGiao hàng nhanh chóng',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildPizzaLogo(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Email',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _buildEmailField(),
                    const SizedBox(height: 10),
                    const Text(
                      'Mật khẩu',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _buildPasswordField(),
                    const SizedBox(height: 20),
                    _buildLoginButton(context),
                    const SizedBox(height: 10),
                    _buildRegisterLink(context),
                    _buildForgotPasswordLink(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPizzaLogo() {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Image.asset(
          'assets/images/logo.png', // Đường dẫn đến file logo.png
          fit: BoxFit.cover, // Đảm bảo hình ảnh lấp đầy container
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Nhập email',
        prefixIcon: const Icon(Icons.email),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: const Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6CC04A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _navToMain(context),
        child: const Text('Đăng nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
      ),
      child: const Text('Quên mật khẩu', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegisterPage()),
      ),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Chưa có tài khoản? ',
              style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: 'Tạo tài khoản',
              style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600), // Màu xanh lá cho "Tạo tài khoản"
            ),
          ],
        ),
      ),
    );
  }

  void _navToMain(BuildContext context) =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const main.MainScreen()));
}