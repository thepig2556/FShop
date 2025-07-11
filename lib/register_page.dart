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

  String _selectedGender = 'Nam';
  bool _obscureText = true; // State để ẩn/hiện mật khẩu
  bool _obscureConfirmText = true; // State để ẩn/hiện xác nhận mật khẩu

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E4057), // Màu xanh navy nhẹ
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 0),
              const Text(
                'Đăng ký',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF8F9FA), // Màu trắng kem
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Đã có thêm nhiều lợi ích, hãy đăng ký tài khoản của bạn bằng cách điền một số thông tin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD5DBDB), // Màu xám nhẹ
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA), // Màu trắng kem
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFieldLabel('Tên'),
                      _buildNameField(),
                      const SizedBox(height: 18),
                      _buildFieldLabel('Email'),
                      _buildEmailField(),
                      const SizedBox(height: 18),
                      _buildFieldLabel('Mật khẩu'),
                      _buildPasswordField(),
                      const SizedBox(height: 18),
                      _buildFieldLabel('Xác nhận mật khẩu'),
                      _buildConfirmPasswordField(),
                      const SizedBox(height: 18),
                      _buildFieldLabel('Ngày sinh'),
                      _buildDobField(),
                      const SizedBox(height: 18),
                      _buildFieldLabel('Số điện thoại'),
                      _buildPhoneField(),
                      const SizedBox(height: 18),
                      _buildFieldLabel('Giới tính'),
                      _buildGenderSelection(),
                      const SizedBox(height: 25),
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

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF2E4057), // Màu xanh navy
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF2E4057),
      ),
      decoration: InputDecoration(
        labelText: 'Nhập tên của bạn',
        labelStyle: const TextStyle(
          color: Color(0xFF5D6D7E),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.person,
          color: Color(0xFF1B5E20),
          size: 24,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF2E4057),
      ),
      decoration: InputDecoration(
        labelText: 'Nhập email của bạn',
        labelStyle: const TextStyle(
          color: Color(0xFF5D6D7E),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.email,
          color: Color(0xFF1565C0),
          size: 24,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập email' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscureText,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF2E4057),
      ),
      decoration: InputDecoration(
        labelText: 'Nhập mật khẩu',
        labelStyle: const TextStyle(
          color: Color(0xFF5D6D7E),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: Color(0xFFC62828),
          size: 24,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFFC62828),
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmText,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF2E4057),
      ),
      decoration: InputDecoration(
        labelText: 'Nhập lại mật khẩu',
        labelStyle: const TextStyle(
          color: Color(0xFF5D6D7E),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFFC62828),
          size: 24,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmText ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFFC62828),
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmText = !_obscureConfirmText;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
        ),
      ),
      validator: (value) => value != _passwordController.text ? 'Mật khẩu không khớp' : null,
    );
  }

  Widget _buildDobField() {
    return TextFormField(
      controller: _dobController,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF2E4057),
      ),
      decoration: InputDecoration(
        labelText: 'Chọn ngày sinh',
        labelStyle: const TextStyle(
          color: Color(0xFF5D6D7E),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: Color(0xFF2E7D32),
          size: 24,
        ),
        suffixIcon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF2E7D32),
          size: 28,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      ),
      readOnly: true,
      validator: (value) => value!.isEmpty ? 'Vui lòng chọn ngày sinh' : null,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF2E7D32),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Color(0xFF2E4057),
                ),
              ),
              child: child!,
            );
          },
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
      keyboardType: TextInputType.phone,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF2E4057),
      ),
      decoration: InputDecoration(
        labelText: 'Nhập số điện thoại',
        labelStyle: const TextStyle(
          color: Color(0xFF5D6D7E),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.phone,
          color: Color(0xFFD84315),
          size: 24,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD84315), width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
    );
  }

  Widget _buildGenderSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildGenderOption('Nam', Icons.male),
          _buildGenderOption('Nữ', Icons.female),
          _buildGenderOption('Khác', Icons.person),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    bool isSelected = _selectedGender == gender;
    Color iconColor = Colors.black;
    if (gender == 'Nam' && isSelected) iconColor = const Color(0xFF1565C0); // Xanh dương
    if (gender == 'Nữ' && isSelected) iconColor = const Color(0xFFEC407A); // Hồng
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B5E20) : const Color(0xFFE0E0E0),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2E4057),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
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
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginFormPage()),
            );
          }
        },
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
}