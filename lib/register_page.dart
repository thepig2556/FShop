import 'package:doan/login_form_page.dart';
import 'package:doan/main.dart' as main; // Import MainScreen từ main.dart
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

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
                'Đăng ký',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Đã có thêm nhiều lợi ích, hãy đăng ký tài khoản của bạn bằng cách điền một số thông tin',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPizzaLogo(),
                      const SizedBox(height: 20),
                      const Text(
                        'Tên',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _buildNameField(),
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
                      const SizedBox(height: 10),
                      const Text(
                        'Xác nhận mật khẩu',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _buildConfirmPasswordField(),
                      const SizedBox(height: 10),
                      const Text(
                        'Ngày sinh',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _buildDobField(),
                      const SizedBox(height: 10),
                      const Text(
                        'Số điện thoại',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _buildPhoneField(),
                      const SizedBox(height: 10),
                      const Text(
                        'Giới tính',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _buildGenderSelection(),
                      const SizedBox(height: 10),
                      _buildRegisterButton(context),
                    ],
                  ),
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

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Nhập tên',
        prefixIcon: const Icon(Icons.person),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Nhập tài khoản',
        prefixIcon: const Icon(Icons.email),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập email' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: const Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Xác nhận mật khẩu',
        prefixIcon: const Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value != _passwordController.text ? 'Mật khẩu không khớp' : null,
    );
  }

  Widget _buildDobField() {
    return TextFormField(
      controller: _dobController,
      decoration: InputDecoration(
        labelText: 'Chọn ngày sinh',
        prefixIcon: const Icon(Icons.calendar_today),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      readOnly: true, // Ngăn người dùng nhập tay
      validator: (value) => value!.isEmpty ? 'Vui lòng chọn ngày sinh' : null,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          });
        }
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Số điện thoại',
        prefixIcon: const Icon(Icons.phone),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Nam', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        Radio<String>(
          value: 'Nam',
          groupValue: 'Nam',
          onChanged: (value) {},
        ),
        const Text('Nữ', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        Radio<String>(
          value: 'Nữ',
          groupValue: 'Nam',
          onChanged: (value) {},
        ),
        const Text('Trống', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        Radio<String>(
          value: 'Trống',
          groupValue: 'Nam',
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6CC04A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginFormPage()),
            );
          }
        },
        child: const Text('Đăng ký', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}