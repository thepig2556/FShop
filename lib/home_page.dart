import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Pizza Dăm Bông Bắp',
      'rate': 4.5,
      'price': '305,000đ',
      'priceNumber': 305000,
      'size': '12inch',
      'image': 'pizza1.png',
      'category': 'Pizza',
      'description': 'Pizza thơm ngon với topping dăm bông bắp tươi, phô mai mozzarella béo ngậy trên nền bánh mỏng giòn.',
    },
    {
      'name': 'Vanilla Ice Cream',
      'rate': 4.2,
      'price': '50,000đ',
      'priceNumber': 50000,
      'size': 'Small',
      'image': 'icecream1.png',
      'category': 'Kem',
      'description': 'Kem vani mịn màng, ngọt ngào với hương vị vani tự nhiên, hoàn hảo cho mùa hè.',
    },
    {
      'name': 'Coca Cola',
      'rate': 4.0,
      'price': '20,000đ',
      'priceNumber': 20000,
      'size': '500ml',
      'image': 'cola1.png',
      'category': 'Nước có ga',
      'description': 'Nước ngọt có ga Coca Cola classic, mang đến cảm giác sảng khoái và tươi mát.',
    },
    {
      'name': 'Pepsi',
      'rate': 4.1,
      'price': '20,000đ',
      'priceNumber': 20000,
      'size': '500ml',
      'image': 'pepsi1.png',
      'category': 'Nước có ga',
      'description': 'Nước ngọt có ga Pepsi với hương vị độc đáo, tạo nên trải nghiệm thú vị.',
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  Set<String> favoriteProducts = {};
  List<String> cart = [];
  String selectedCategory = 'Pizza';

  @override
  void initState() {
    super.initState();
    _filterProducts();
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = allProducts.where((p) {
        final matchesCategory = p['category'] == selectedCategory;
        final matchesKeyword = p['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        return matchesCategory && matchesKeyword;
      }).toList();
    });
  }

  void _searchProducts(String keyword) => _filterProducts();

  void _selectCategory(String category) {
    selectedCategory = category;
    _filterProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCarousel(),
                    _buildCategoryRow(),
                    _buildProductGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5C7C99), Color(0xFF7B9BC4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF5C7C99)),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhà số 555, Vietnam, Ninh Bình, Tây Ninh',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _searchProducts,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm những gì bạn cần?',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 160,
          enlargeCenterPage: true,
          autoPlay: true,
          viewportFraction: 0.85,
        ),
        items: [
          'assets/images/pizza1.png',
          'assets/images/pizza2.png',
          'assets/images/pz3.png',
          'assets/images/kem1.png',
          'assets/images/kem2.png',
          'assets/images/cola.png'
        ].map((image) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryItem('Pizza', Icons.local_pizza),
          _buildCategoryItem('Kem', Icons.icecream),
          _buildCategoryItem('Nước có ga', Icons.local_drink),
          _buildCategoryItem('Cafe', Icons.coffee),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    final isSelected = title == selectedCategory;
    return GestureDetector(
      onTap: () => _selectCategory(title),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange[400] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.orange[400] : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.7,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          final name = product['name'] ?? 'Unknown';
          final rate = product['rate'] ?? 0.0;
          final price = product['price'] ?? '0đ';
          final priceNumber = product['priceNumber'] ?? 0;
          final size = product['size'] ?? 'N/A';
          final image = product['image'] ?? 'default.png';
          final description = product['description'] ?? '';
          final isFav = favoriteProducts.contains(name);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(
                    name: name,
                    rate: rate,
                    price: price,
                    priceNumber: priceNumber,
                    image: image,
                    description: description,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh + yêu thích
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          image: DecorationImage(
                            image: AssetImage('assets/images/$image'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isFav
                                  ? favoriteProducts.remove(name)
                                  : favoriteProducts.add(name);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Nội dung
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 0),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              rate.toString(),
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 0),
                        Text(size,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600])),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                price,
                                style: TextStyle(
                                  fontSize: 20, // Giảm font để tránh tràn
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  cart.add(name);
                                });
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 25, // Icon nhỏ lại
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}