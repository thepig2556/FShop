import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorite_provider.dart';
import 'product.dart';
import 'product_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteProvider>().favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu thích'),
        centerTitle: true,
        backgroundColor: const Color(0xFF5C7C99),
        foregroundColor: Colors.white,
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Text(
          'Chưa có món ăn yêu thích nào.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final product = favorites[index];
          return ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.image.startsWith('http')
                  ? Image.network(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 60),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              )
                  : Image.asset(
                'assets/images/${product.image}',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(product.name),
            subtitle: Text('${product.rate} ★ - ${product.priceString}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    name: product.name,
                    rate: product.rate,
                    price: product.priceString,
                    priceNumber: product.price,
                    image: product.image,
                    description: product.description,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}