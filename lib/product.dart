class Product {
  final String name;
  final String image;
  final double rate;
  final String description;
  final int price; // Lấy từ API's "price"
  final String priceString; // Định dạng giá (ví dụ: "175000đ")

  Product({
    required this.name,
    required this.image,
    required this.rate,
    required this.description,
    required this.price,
  }) : priceString = '$priceđ'; // Khởi tạo tại đây, không đưa vào tham số

  @override
  bool operator ==(Object other) {
    return other is Product && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
