import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_detail_page.dart';

// Bản ánh xạ category từ int sang tên hiển thị
const Map<int, String> categoryMap = {
  0: 'Pizza',
  1: 'Kem',
  2: 'Nước có ga',
  3: 'Cafe',
};

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];
  Set<String> favoriteProducts = {};
  List<String> cart = [];
  int selectedCategory = 0; // Sử dụng int thay vì String
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://apitaofood.onrender.com/foods'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Decoded data length: ${data.length}');
        if (data.isEmpty) {
          print('Warning: API returned empty data');
        }
        setState(() {
          allProducts = data.map((item) {
            print('Raw item: $item');
            int categoryValue = 0; // Giá trị mặc định
            try {
              if (item['category'] != null) {
                final categoryStr = item['category'].toString();
                categoryValue = int.parse(categoryStr); // Chuyển đổi String sang int
              }
            } catch (e) {
              print('Error parsing category: $e, using default 0');
            }
            print('Processed category: $categoryValue');
            final image = item['image'] ?? 'default.png';
            print('Processed image: $image');
            return {
              'name': item['name'] ?? 'Unknown',
              'rate': item['rate'] != null ? double.parse(item['rate'].toString()) : 0.0,
              'price': item['price'] != null ? '${item['price']}đ' : '0đ',
              'priceNumber': item['priceNumber'] != null ? int.parse(item['priceNumber'].toString()) : 0,
              'size': item['size'] ?? 'N/A',
              'image': image,
              'category': categoryValue,
              'description': item['description'] ?? '',
            };
          }).toList();
          filteredProducts = allProducts.where((p) => p['category'] == selectedCategory).toList();
          isLoading = false;
          print('All products count: ${allProducts.length}');
          if (allProducts.isEmpty) {
            print('Warning: No products after processing');
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi API: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching products: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
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
      print('Filtered products count: ${filteredProducts.length}');
    });
  }

  void _searchProducts(String keyword) => _filterProducts();

  void _selectCategory(int category) {
    setState(() {
      selectedCategory = category;
      filteredProducts = allProducts.where((p) => p['category'] == category).toList();
      print('Selected category: $category, Filtered count: ${filteredProducts.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : allProducts.isEmpty
            ? const Center(child: Text('Không có dữ liệu sản phẩm hoặc lỗi API'))
            : Column(
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
        items: allProducts.map((product) {
          final image = product['image'] ?? 'default.png';
          final ImageProvider imageProvider = image.startsWith('http')
              ? NetworkImage(image) as ImageProvider
              : AssetImage('assets/images/$image') as ImageProvider;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  print('Error loading image: $exception');
                },
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
          _buildCategoryItem(0, Icons.local_pizza),
          _buildCategoryItem(1, Icons.icecream),
          _buildCategoryItem(2, Icons.local_drink),
          _buildCategoryItem(3, Icons.coffee),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(int categoryId, IconData icon) {
    final isSelected = categoryId == selectedCategory;
    final categoryName = categoryMap[categoryId] ?? 'Unknown';
    return GestureDetector(
      onTap: () => _selectCategory(categoryId),
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
            categoryName,
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

          final ImageProvider imageProvider = image.startsWith('http')
              ? NetworkImage(image) as ImageProvider
              : AssetImage('assets/images/$image') as ImageProvider;

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
                            image: imageProvider,
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              print('Error loading product image: $exception');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
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