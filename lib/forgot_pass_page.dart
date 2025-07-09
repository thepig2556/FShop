import 'package:doan/login_form_page.dart';
import 'package:doan/main.dart' as main; // Import MainScreen từ main.dart
import 'package:doan/register_page.dart';
import 'package:flutter/material.dart';

// Form mới cho đặt lại mật khẩu
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

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
              const Text(
                'Đặt lại mật khẩu',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 0),
              const Column(
                children: [
                  Text(
                    "Bảo mật luôn là ưu tiên hàng đầu – hãy đặt lại mật khẩu an toàn hơn.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0),
                  Text(
                    "Chúng tôi luôn sẵn sàng giúp bạn lấy lại quyền truy cập.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Quên mật khẩu không sao – chỉ cần vài bước để quay lại.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
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
                    const SizedBox(height: 0),
                    const Text(
                      'Mật khẩu mới',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildNewPasswordField(),
                    const SizedBox(height: 10),
                    const Text(
                      'Xác nhận mật khẩu mới',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(context),
                    const SizedBox(height: 10),
                    _buildBackLink(context),
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
        child: const Icon(Icons.local_pizza, size: 100, color: Colors.grey),
      ),
    );
  }

  Widget _buildNewPasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Nhập mật khẩu mới',
        prefixIcon: const Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Nhập lại mật khẩu mới',
        prefixIcon: const Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6CC04A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          // Thêm logic xác nhận mật khẩu ở đây nếu cần
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginFormPage()),
          );
        },
        child: const Text('Xác nhận', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildBackLink(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Quay lại', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue)),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
              const Text(
                'Quên mật khẩu',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 0),
              const Column(
                children: [
                  Text(
                    "Bảo mật luôn là ưu tiên hàng đầu – hãy đặt lại mật khẩu an toàn hơn.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0),
                  Text(
                    "Chúng tôi luôn sẵn sàng giúp bạn lấy lại quyền truy cập.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Quên mật khẩu không sao – chỉ cần vài bước để quay lại.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
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
                    const SizedBox(height: 0),
                    const Text(
                      'Email',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildEmailField(),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Thêm logic gửi email ở đây nếu cần
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6CC04A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(Icons.send, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Mã đăng nhập',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildOTPField(),
                    const SizedBox(height: 20),
                    _buildLoginButton(context),
                    const SizedBox(height: 10),
                    _buildBackLink(context),
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
        child: const Icon(Icons.local_pizza, size: 100, color: Colors.grey),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Nhập tài khoản',
        prefixIcon: const Icon(Icons.email),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildOTPField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Nhập mã',
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
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
          );
        },
        child: const Text('Xác minh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildBackLink(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Quay lại', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue)),
    );
  }
}