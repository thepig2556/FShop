import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'product.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  Future<void> fetchFoods() async {
    try {
      final response = await http.get(Uri.parse('https://apitaofood.onrender.com/foods'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Product> foods = data.map((json) {
          return Product(
            name: json['name'] ?? '',
            image: json['image'] ?? '',
            rate: (json['rate'] ?? 0.0).toDouble(),
            description: json['description'] ?? '',
            price: json['price'] ?? 0,
          );
        }).toList();
      }
    } catch (e) {
      print('Error fetching foods: $e');
    }
  }

  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }
}