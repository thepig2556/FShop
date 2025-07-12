import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header với gradient và nút quay lại
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(25, 15, 24, 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6284AF),
                      Color(0xFF8BA3C7),
                      Color(0xFFB8C5D6),
                    ],
                    stops: [0.0, 0.6, 1.0],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6284AF).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Nút quay lại
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            print('Đã nhấn nút quay lại');
                            Navigator.pop(context); // Quay lại ProfilePage
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 65,
                        backgroundColor: Color(0xFFF0F4F8),
                        child: Icon(
                          Icons.person_rounded,
                          size: 80,
                          color: Color(0xFF6284AF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tên người dùng
                    const Text(
                      "Pizza",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Các trường thông tin
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6284AF).withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    _UserInfoField(
                      title: 'Họ và tên',
                      icon: Icons.person,
                      value: 'Pizza',
                    ),
                    _UserInfoField(
                      title: 'Email',
                      icon: Icons.email,
                      value: 'pizza@gmail.com',
                    ),
                    _UserInfoField(
                      title: 'Số điện thoại',
                      icon: Icons.phone,
                      value: 'xxx.xxx.xxx',
                    ),
                    _UserInfoField(
                      title: 'Địa chỉ',
                      icon: Icons.location_on,
                      value: 'Nhà số 555, Việt Nam\nNinh Bình, Tây Ninh',
                      isMultiline: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserInfoField extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final bool isMultiline;

  const _UserInfoField({
    required this.title,
    required this.icon,
    required this.value,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Chỉnh sửa $title'),
                  content: TextField(
                    decoration: InputDecoration(
                      labelText: title,
                      hintText: value,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: isMultiline ? 3 : 1,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy', style: TextStyle(color: Color(0xFF6284AF))),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Lưu', style: TextStyle(color: Color(0xFF6284AF))),
                    ),
                  ],
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6284AF).withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6284AF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFF6284AF),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.edit,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}