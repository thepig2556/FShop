import 'package:doan/login_form_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool _obscureText = true;
  bool _obscureConfirmText = true;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String avatarUrl;
        switch (_selectedGender) {
          case 'Nam':
            avatarUrl = 'https://firebasestorage.googleapis.com/v0/b/tousehao.appspot.com/o/avt.png?alt=media&token=d4b325e8-c4f1-49e3-8438-3f980dd4a4bf';
            break;
          case 'Nữ':
            avatarUrl = 'https://firebasestorage.googleapis.com/v0/b/tousehao.appspot.com/o/avt.png?alt=media&token=d4b325e8-c4f1-49e3-8438-3f980dd4a4bf';
            break;
          default:
            avatarUrl = 'https://firebasestorage.googleapis.com/v0/b/tousehao.appspot.com/o/avt.png?alt=media&token=d4b325e8-c4f1-49e3-8438-3f980dd4a4bf';
        }

        // Prepare data for API
        final userData = {
          'id': userCredential.user!.uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'dob': _dobController.text.trim(),
          'phone': _phoneController.text.trim(),
          'gender': _selectedGender,
          'address': '',
          'role': 'Customer',
          'avatar': avatarUrl,
        };

        final response = await http.post(
          Uri.parse('https://apitaofood.onrender.com/Users'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          await userCredential.user!.sendEmailVerification();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công! Vui lòng kiểm tra email để xác nhận.')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginFormPage()),
          );
        } else {
          throw Exception('Đã có lỗi xảy ra khi gọi API');
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'Email đã được sử dụng';
            break;
          case 'invalid-email':
            message = 'Email không hợp lệ';
            break;
          case 'weak-password':
            message = 'Mật khẩu quá yếu';
            break;
          default:
            message = 'Đã có lỗi xảy ra, vui lòng thử lại';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã có lỗi xảy ra, vui lòng thử lại')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E4057),
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
                  color: Color(0xFFF8F9FA),
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Đã có thêm nhiều lợi ích, hãy đăng ký tài khoản của bạn bằng cách điền một số thông tin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD5DBDB),
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(25),
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
          color: Color(0xFF2E4057),
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
      validator: (value) {
        if (value!.isEmpty) return 'Vui lòng nhập email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Email không hợp lệ';
        }
        return null;
      },
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
      validator: (value) {
        if (value!.isEmpty) return 'Vui lòng nhập mật khẩu';
        if (value.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
        return null;
      },
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
      validator: (value) {
        if (value!.isEmpty) return 'Vui lòng nhập số điện thoại';
        if (!RegExp(r'^\+?\d{9,12}$').hasMatch(value)) {
          return 'Số điện thoại không hợp lệ';
        }
        return null;
      },
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
    if (gender == 'Nam' && isSelected) iconColor = const Color(0xFF1565C0);
    if (gender == 'Nữ' && isSelected) iconColor = const Color(0xFFEC407A);
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
        onPressed: _isLoading ? null : _register,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
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