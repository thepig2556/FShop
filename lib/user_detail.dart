import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6ED),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF77C29F),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Hồ sơ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Để icon back canh giữa
                ],
              ),
            ),
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.amber),
            ),
            const SizedBox(height: 8),
            const Text("Pizza", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),
            const _UserInfoField(
              title: 'Họ và tên',
              icon: Icons.person,
              value: 'Pizza',
            ),
            const _UserInfoField(
              title: 'Email',
              icon: Icons.email,
              value: 'pizza@gmail.com',
            ),
            const _UserInfoField(
              title: 'Số điện thoại',
              icon: Icons.phone,
              value: 'xxx.xxx.xxx',
            ),
            const _UserInfoField(
              title: 'Địa chỉ',
              icon: Icons.location_on,
              value: 'Nhà số 555, Việt Nam\n, Ninh Bình, Tây Ninh',
              isMultiline: true,
            ),
          ],
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.only(top: 4),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const Icon(Icons.edit, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
