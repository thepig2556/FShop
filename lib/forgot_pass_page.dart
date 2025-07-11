import 'package:doan/login_form_page.dart';
import 'package:flutter/material.dart';

// Form mới cho đặt lại mật khẩu
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isButtonEnabled = false;

  // Trạng thái kiểm tra tiêu chí
  bool _lengthCriteriaMet = false;
  bool _typeCriteriaMet = false;
  bool _matchCriteriaMet = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _checkLengthCriteria(String password) {
    return password.length >= 8 && password.length <= 30;
  }

  bool _checkTypeCriteria(String password) {
    int typeCount = 0;
    if (password.contains(RegExp(r'[0-9]'))) typeCount++;
    if (password.contains(RegExp(r'[a-zA-Z]'))) typeCount++;
    if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) typeCount++;
    return typeCount >= 2;
  }

  bool _checkPasswordsMatch() {
    return _newPasswordController.text == _confirmPasswordController.text &&
        _newPasswordController.text.isNotEmpty;
  }

  void _updateCriteria() {
    setState(() {
      _lengthCriteriaMet = _checkLengthCriteria(_newPasswordController.text);
      _typeCriteriaMet = _checkTypeCriteria(_newPasswordController.text);
      _matchCriteriaMet = _checkPasswordsMatch();
      _isButtonEnabled = _lengthCriteriaMet && _typeCriteriaMet && _matchCriteriaMet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E4057), // Màu xanh navy nhẹ giống trang đăng nhập
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
                style: TextStyle(
                  color: Color(0xFFF8F9FA), // Màu trắng kem
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Vui lòng thiết lập mật khẩu mới\ncho tài khoản của bạn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD5DBDB), // Màu xám nhẹ
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              _buildPizzaLogo(),
              const SizedBox(height: 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFieldLabel('Mật khẩu mới'),
                    _buildPasswordField(),
                    const SizedBox(height: 15),
                    _buildFieldLabel('Xác nhận mật khẩu mới'),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 10),
                    _buildPasswordCriteria(),
                    const SizedBox(height: 20),
                    _buildConfirmButton(context),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/logo1.png',
            fit: BoxFit.cover,
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

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF2E4057),
      ),
      decoration: InputDecoration(
        labelText: 'Nhập mật khẩu mới',
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
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFFC62828),
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
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
      onChanged: (value) {
        _updateCriteria();
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF2E4057),
      ),
      decoration: InputDecoration(
        labelText: 'Nhập lại mật khẩu mới',
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
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFFC62828),
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
      onChanged: (value) {
        _updateCriteria();
      },
    );
  }

  Widget _buildPasswordCriteria() {
    return Column(
      children: [
        _buildCriteriaRow(_lengthCriteriaMet, 'Mật khẩu bao gồm 8-30 số, chữ cái hoặc ký tự'),
        _buildCriteriaRow(_typeCriteriaMet, 'Tối thiểu gồm 2 loại ký tự khác nhau'),
        _buildCriteriaRow(_matchCriteriaMet, 'Đảm bảo hai lần nhập mật khẩu giống nhau'),
      ],
    );
  }

  Widget _buildCriteriaRow(bool isMet, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMet ? const Color(0xFF1B5E20) : const Color(0xFFE0E0E0),
            ),
            child: isMet
                ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 14,
            )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isMet ? const Color(0xFF2E4057) : const Color(0xFF5D6D7E),
                fontSize: 14,
                fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _isButtonEnabled ? const Color(0xFF1B5E20) : const Color(0xFFE0E0E0),
          foregroundColor: _isButtonEnabled ? Colors.white : const Color(0xFF5D6D7E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: _isButtonEnabled ? 3 : 0,
        ),
        onPressed: _isButtonEnabled
            ? () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginFormPage()),
          );
        }
            : null,
        child: const Text(
          'Xác nhận',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBackLink(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: const Text(
        'Quay lại',
        style: TextStyle(
          color: Color(0xFF1B5E20),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isCodeRequested = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E4057), // Màu xanh navy nhẹ giống trang đăng nhập
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
                style: TextStyle(
                  color: Color(0xFFF8F9FA), // Màu trắng kem
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Vui lòng nhập tài khoản\ncần tìm lại mật khẩu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD5DBDB), // Màu xám nhẹ
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              _buildPizzaLogo(),
              const SizedBox(height: 30),
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
                      _buildFieldLabel('Email'),
                      _buildEmailField(),
                      if (_isCodeRequested) ...[
                        const SizedBox(height: 25),
                        _buildFieldLabel('Mã xác nhận'),
                        _buildOTPField(),
                      ],
                      const SizedBox(height: 25),
                      _buildVerifyButton(context),
                      const SizedBox(height: 15),
                      _buildBackLink(context),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/logo1.png',
            fit: BoxFit.cover,
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

  Widget _buildEmailField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
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
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 56,
          width: 56,
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });
                await Future.delayed(const Duration(seconds: 3));
                setState(() {
                  _isLoading = false;
                  _isCodeRequested = true;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              padding: EdgeInsets.zero,
            ),
            child: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.send, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPField() {
    return TextFormField(
      controller: _otpController,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF2E4057),
      ),
      decoration: InputDecoration(
        labelText: 'Nhập mã xác nhận',
        labelStyle: const TextStyle(
          color: Color(0xFF5D6D7E),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: Color(0xFFC62828),
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
          borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return SizedBox(
      height: 56,
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
          );
        },
        child: const Text(
          'Xác minh',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBackLink(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: const Text(
        'Quay lại',
        style: TextStyle(
          color: Color(0xFF1B5E20),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}