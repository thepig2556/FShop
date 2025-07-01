import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final List<Product> favoriteItems = [
    Product("Pizza ngập phô mai", "https://i.imgur.com/1YcWl0N.jpg", 4.5, "9inch", 175000),
    Product("Pizza Đậm Bỏng Bắp", "https://i.imgur.com/Uw4Fqxy.jpg", 4.0, "12inch", 305000),
    Product("Pizza hải sản", "https://i.imgur.com/yF6psuQ.jpg", 4.2, "9inch", 225000),
    Product("Kem vani", "https://i.imgur.com/WvFIR61.jpg", 3.8, "1", 35000),
    Product("Cocola", "https://i.imgur.com/z5rW1Ew.png", 3.7, "1", 15000),
    Product("Kem socola", "https://i.imgur.com/KnwWWmW.jpg", 4.5, "1", 35000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF8F1),
      appBar: AppBar(
        backgroundColor: Color(0xFF6FC78E),
        title: Text("Yêu thích", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm sản phẩm',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.tune),
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
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        items: [
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.imagePath,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Icon(Icons.favorite, color: Colors.red),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
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
                SizedBox(height: 4),
                Text(
                  "${product.size}/${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}đ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8, bottom: 8),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.green,
                child: Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
