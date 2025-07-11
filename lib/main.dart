import 'package:doan/home_page.dart';
import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'favorite_page.dart';
import 'profile.dart';
import 'login_page.dart'; // Import trang login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza MART',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // Bắt đầu từ trang đăng nhập
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 3; // Mặc định trang yêu thích

  final List<Widget> pages = [
    HomePage(), // Index 0
    Center(child: Text("Trang tìm kiếm")), // Index 1
    CartPage(), // Index 2
    FavoritePage(),                        // Index 3
    ProfilePage(),                         // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.category), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}