import 'package:doan/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'favorite_page.dart';
import 'profile.dart';
import 'login_page.dart'; // Import trang login

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    User? user = FirebaseAuth.instance.currentUser;
    if(userId!=null)
      {
        if(user!.emailVerified)
          {
            return MaterialApp(
                title: 'Pizza MART',
                debugShowCheckedModeBanner: false,
                home: const MainScreen()
            );
          }
        else
          {
            return MaterialApp(
                title: 'Pizza MART',
                debugShowCheckedModeBanner: false,
                home: const LoginPage()
            );
          }
      }
    else{
      return MaterialApp(
          title: 'Pizza MART',
          debugShowCheckedModeBanner: false,
          home: const LoginPage()
      );
    }
    // return MaterialApp(
    //     title: 'Pizza MART',
    //     debugShowCheckedModeBanner: false,
    //     home: const LoginPage()
    // );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0; // Mặc định trang yêu thích

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