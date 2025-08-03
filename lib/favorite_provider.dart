import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Product> _favorites = [];
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? _userId;

  List<Product> get favorites => _favorites;

  FavoriteProvider() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    _userId = FirebaseAuth.instance.currentUser?.uid;
    if (_userId != null) {
      await _fetchFavoritesFromFirebase();
    }
  }

  Future<void> fetchFoods() async {
    try {
      final response = await http.get(Uri.parse('https://apitaofood.onrender.com/foods'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Fetched ${data.length} foods from API');
      }
    } catch (e) {
      print('Error fetching foods: $e');
    }
  }

  Future<void> _fetchFavoritesFromFirebase() async {
    if (_userId == null) return;

    try {
      final snapshot = await _database
          .child('MobileNangCao/Favorites/$_userId')
          .get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        _favorites.clear();
        data.forEach((key, value) {
          final productData = value as Map<dynamic, dynamic>;
          _favorites.add(Product(
            id: int.parse(key),
            name: productData['name'] ?? '',
            image: productData['image'] ?? '',
            rate: (productData['rate'] ?? 0.0).toDouble(),
            description: productData['description'] ?? '',
            price: productData['price'] ?? 0,
          ));
        });
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching favorites from Firebase: $e');
    }
  }

  Future<void> toggleFavorite(Product product) async {
    if (_userId == null) {
      print('User not logged in');
      return;
    }

    final productRef = _database
        .child('MobileNangCao/Favorites/$_userId/${product.id}');

    if (_favorites.contains(product)) {
      _favorites.remove(product);
      try {
        await productRef.remove();
        print('Removed favorite ${product.id} from Firebase');
      } catch (e) {
        print('Error removing favorite from Firebase: $e');
        _favorites.add(product);
      }
    } else {
      _favorites.add(product);
      try {
        await productRef.set({
          'id': product.id,
          'name': product.name,
          'image': product.image,
          'rate': product.rate,
          'description': product.description,
          'price': product.price,
        });
        print('Added favorite ${product.id} to Firebase');
      } catch (e) {
        print('Error adding favorite to Firebase: $e');
        _favorites.remove(product);
      }
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }
}