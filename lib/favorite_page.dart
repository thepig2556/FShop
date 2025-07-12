import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final List<Product> favoriteItems = [
    Product("Pizza ngập phô mai", "assets/images/pizza1.png", 4.5, "9inch", 175000),
    Product("Pizza Dăm Bông Bắp", "assets/images/pizza2.png", 4.0, "12inch", 305000),
    Product("Pizza hải sản", "assets/images/pz3.png", 4.2, "9inch", 225000),
    Product("Kem vani", "assets/images/kem1.png", 3.8, "1", 35000),
    Product("Kem socola", "assets/images/kem2.png", 4.5, "1", 35000),
    Product("Cocola", "assets/images/cola.png", 3.7, "1", 15000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6284AF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6284AF),
        title: const Text("Yêu thích", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false, // ❌ Không hiển thị nút quay lại
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm sản phẩm',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.tune),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final product = favoriteItems[index];
                return ProductCard(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String imagePath;
  final double rating;
  final String size;
  final int price;

  Product(this.name, this.imagePath, this.rating, this.size, this.price);
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.imagePath.startsWith('http')
                    ? Image.network(
                  product.imagePath,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  product.imagePath,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                right: 6,
                top: 6,
                child: Icon(Icons.favorite, color: Colors.red),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      Icons.star,
                      size: 16,
                      color: index < product.rating.round()
                          ? Colors.orange
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${product.size}/${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}đ",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.green,
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
