class Product {
  final int id; // Thêm id
  final String name;
  final String image;
  final double rate;
  final String description;
  final int price;
  final String priceString;

  Product({
    required this.id, // Thêm id
    required this.name,
    required this.image,
    required this.rate,
    required this.description,
    required this.price,
  }) : priceString = '$priceđ';

  @override
  bool operator ==(Object other) {
    return other is Product && other.id == id; // So sánh bằng id
  }

  @override
  int get hashCode => id.hashCode; // Dùng id cho hashCode
}