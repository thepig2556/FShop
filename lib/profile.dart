import 'package:doan/login_form_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      theme: ThemeData(
        primaryColor: const Color(0xFF6284AF),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF2C3E50)),
          bodyMedium: TextStyle(color: Color(0xFF64748B)),
        ),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Pizza';
  String userEmail = 'pizza@gmail.com';
  String? avatarUrl;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() {
        errorMessage = 'Không tìm thấy người dùng';
      });
      return;
    }

    final url = Uri.parse('https://apitaofood.onrender.com/users/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userName = data['name'] ?? "Pizza";
          userEmail = data['email'] ?? "pizza@gmail.com";
          avatarUrl = data['avatar'];
        });
      } else {
        setState(() {
          errorMessage = 'Không thể tải dữ liệu người dùng';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tải dữ liệu người dùng')),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi kết nối đến API';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi kết nối đến API')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: errorMessage != null
          ? Center(child: Text(errorMessage!))
          : SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 25, 24, 20),
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
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.9),
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: const Color(0xFFF0F4F8),
                            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                            child: avatarUrl == null
                                ? const Icon(
                              Icons.person_rounded,
                              size: 80,
                              color: Color(0xFF6284AF),
                            )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ProfileMenuItem(
                      icon: Icons.person_rounded,
                      label: 'Chi tiết người dùng',
                      color: const Color(0xFF6284AF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserDetailPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const ProfileMenuItem(
                      icon: Icons.settings_rounded,
                      label: 'Cài đặt',
                      color: Color(0xFF6284AF),
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const ProfileMenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Trợ giúp',
                      color: Color(0xFF6284AF),
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const ProfileMenuItem(
                      icon: Icons.language_rounded,
                      label: 'Ngôn ngữ',
                      color: Color(0xFF6284AF),
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      label: 'Đăng xuất',
                      color: Color(0xFFE74C3C),
                      isLogout: true,
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginFormPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
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

class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const QuickActionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isLogout;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? color : const Color(0xFF2C3E50),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}