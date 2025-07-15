import 'package:doan/user_detail.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationSelectionScreen(),
    );
  }
}

class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final List<String> cities = [
    'Hà Nội', 'Hồ Chí Minh', 'Đà Nẵng', 'Hải Phòng', 'Cần Thơ',
    'An Giang', 'Bà Rịa - Vũng Tàu', 'Bắc Giang', 'Bắc Kạn', 'Bạc Liêu',
    'Bến Tre', 'Bình Định', 'Bình Dương', 'Bình Phước', 'Bình Thuận',
    'Cà Mau', 'Cao Bằng', 'Đắk Lắk', 'Đắk Nông', 'Điện Biên',
    'Đồng Nai', 'Đồng Tháp', 'Gia Lai', 'Hà Giang', 'Hà Nam',
    'Hà Tĩnh', 'Hải Dương', 'Hậu Giang', 'Hòa Bình', 'Hưng Yên',
    'Khánh Hòa', 'Kiên Giang', 'Kon Tum', 'Lai Châu', 'Lâm Đồng',
    'Lạng Sơn', 'Lào Cai', 'Long An', 'Nam Định', 'Nghệ An',
    'Ninh Bình', 'Ninh Thuận', 'Phú Thọ', 'Phú Yên', 'Quảng Bình',
    'Quảng Nam', 'Quảng Ngãi', 'Quảng Ninh', 'Quảng Trị', 'Sóc Trăng',
    'Sơn La', 'Tây Ninh', 'Thái Bình', 'Thái Nguyên', 'Thanh Hóa',
    'Thừa Thiên Huế', 'Tiền Giang', 'Trà Vinh', 'Tuyên Quang', 'Vĩnh Long',
    'Vĩnh Phúc', 'Yên Bái', 'Phú Quốc'
  ];

  final Map<String, List<String>> districts = {
    'Hà Nội': ['Ba Đình', 'Hoàn Kiếm', 'Tây Hồ', 'Long Biên', 'Cầu Giấy', 'Đống Đa', 'Hai Bà Trưng', 'Hoàng Mai', 'Thanh Xuân', 'Nam Từ Liêm', 'Bắc Từ Liêm', 'Hà Đông', 'Sơn Tây', 'Ba Vì', 'Phúc Thọ', 'Đan Phượng', 'Hoài Đức', 'Quốc Oai', 'Thạch Thất', 'Chương Mỹ', 'Thanh Oai', 'Thường Tín', 'Phú Xuyên', 'Ứng Hòa', 'Mỹ Đức', 'Sóc Sơn', 'Đông Anh', 'Gia Lâm'],
    'Hồ Chí Minh': ['Quận 1', 'Quận 2', 'Quận 3', 'Quận 4', 'Quận 5', 'Quận 6', 'Quận 7', 'Quận 8', 'Quận 9', 'Quận 10', 'Quận 11', 'Quận 12', 'Bình Thạnh', 'Gò Vấp', 'Tân Bình', 'Tân Phú', 'Phú Nhuận', 'Thủ Đức', 'Bình Tân', 'Hóc Môn', 'Củ Chi', 'Bình Chánh', 'Nhà Bè', 'Cần Giờ'],
    'Đà Nẵng': ['Hải Châu', 'Thanh Khê', 'Sơn Trà', 'Ngũ Hành Sơn', 'Cẩm Lệ', 'Liên Chiểu', 'Hòa Vang', 'Hoàng Sa'],
    'Hải Phòng': ['Hồng Bàng', 'Ngô Quyền', 'Lê Chân', 'Kiến An', 'Hải An', 'Đồ Sơn', 'Dương Kinh', 'Kênh Dương', 'An Lão', 'An Dương', 'Bạch Long Vĩ', 'Cát Hải', 'Tiên Lãng', 'Vĩnh Bảo', 'Thủy Nguyên'],
    'Cần Thơ': ['Ninh Kiều', 'Bình Thủy', 'Cái Răng', 'Ô Môn', 'Thốt Nốt', 'Vĩnh Thạnh', 'Cờ Đỏ', 'Phong Điền', 'Thới Lai'],
    'An Giang': ['Long Xuyên', 'Châu Đốc', 'An Phú', 'Châu Phú', 'Châu Thành', 'Chợ Mới', 'Phú Tân', 'Tân Châu', 'Tri Tôn', 'Tịnh Biên'],
    'Bà Rịa - Vũng Tàu': ['Vũng Tàu', 'Bà Rịa', 'Châu Đức', 'Côn Đảo', 'Đất Đỏ', 'Long Điền', 'Tân Thành', 'Xuyên Mộc'],
    'Bắc Giang': ['Bắc Giang', 'Hiệp Hòa', 'Lạng Giang', 'Lục Nam', 'Lục Ngạn', 'Sơn Động', 'Tân Yên', 'Việt Yên', 'Yên Dũng', 'Yên Thế'],
    'Bắc Kạn': ['Bắc Kạn', 'Ba Bể', 'Bạch Thông', 'Chợ Đồn', 'Chợ Mới', 'Na Rì', 'Ngân Sơn', 'Pác Nặm'],
    'Bạc Liêu': ['Bạc Liêu', 'Đông Hải', 'Giá Rai', 'Hòa Bình', 'Hồng Dân', 'Phước Long', 'Vĩnh Lợi'],
    'Bến Tre': ['Bến Tre', 'Ba Tri', 'Bình Đại', 'Châu Thành', 'Chợ Lách', 'Giồng Trôm', 'Mỏ Cày Bắc', 'Mỏ Cày Nam', 'Thạnh Phú'],
    'Bình Định': ['Quy Nhơn', 'An Lão', 'An Nhơn', 'Hoài Ân', 'Hoài Nhơn', 'Phù Cát', 'Phù Mỹ', 'Tây Sơn', 'Tuy Phước', 'Vân Canh', 'Vĩnh Thạnh'],
    'Bình Dương': ['Thuận An', 'Dĩ An', 'Bến Cát', 'Tân Uyên', 'Bắc Tân Uyên', 'Phú Giáo', 'Dầu Tiếng'],
    'Bình Phước': ['Đồng Xoài', 'Bình Long', 'Bù Đăng', 'Bù Đốp', 'Bù Gia Mập', 'Chơn Thành', 'Đồng Phú', 'Hớn Quản', 'Lộc Ninh', 'Phú Riềng'],
    'Bình Thuận': ['Phan Thiết', 'Bắc Bình', 'Đồng Phú', 'Hàm Thuận Bắc', 'Hàm Thuận Nam', 'Hàm Tân', 'La Gi', 'Phú Quý', 'Tánh Linh', 'Tuy Phong'],
    'Cà Mau': ['Cà Mau', 'Cái Nước', 'Đầm Dơi', 'Ngọc Hiển', 'Năm Căn', 'Phú Tân', 'Thới Bình', 'Trần Văn Thời', 'U Minh'],
    'Cao Bằng': ['Cao Bằng', 'Bảo Lạc', 'Bảo Lâm', 'Hà Quảng', 'Hạ Lang', 'Nguyên Bình', 'Phục Hòa', 'Quảng Uyên', 'Thạch An', 'Trà Lĩnh', 'Trùng Khánh'],
    'Đắk Lắk': ['Buôn Ma Thuột', 'Buôn Đôn', 'Cư Kuin', 'Cư M’gar', 'Ea H’Leo', 'Ea Kar', 'Ea Súp', 'Krông Ana', 'Krông Bông', 'Krông Năng', 'Krông Pắc', 'Lắk', 'M’Đrắk'],
    'Đắk Nông': ['Gia Nghĩa', 'Cư Jút', 'Đắk Glong', 'Đắk Mil', 'Đắk R’lấp', 'Đắk Song', 'Krông Nô', 'Tuy Đức'],
    'Điện Biên': ['Điện Biên Phủ', 'Điện Biên', 'Điện Biên Đông', 'Mường Ảng', 'Mường Chà', 'Mường Lay', 'Mường Nhé', 'Tủa Chùa', 'Tuần Giáo'],
    'Đồng Nai': ['Biên Hòa', 'Long Khánh', 'Định Quán', 'Long Thành', 'Nhơn Trạch', 'Tân Phú', 'Thống Nhất', 'Trảng Bom', 'Vĩnh Cửu', 'Xuân Lộc'],
    'Đồng Tháp': ['Cao Lãnh', 'Sa Đéc', 'Hồng Ngự', 'Cao Lãnh', 'Châu Thành', 'Hồng Ngự', 'Lai Vung', 'Lấp Vò', 'Tam Nông', 'Thanh Bình', 'Tháp Mười'],
    'Gia Lai': ['Pleiku', 'An Khê', 'Ayun Pa', 'Chư Păh', 'Chư Prông', 'Chư Sê', 'Đak Đoa', 'Đak Pơ', 'Ia Grai', 'Ia Pa', 'KBang', 'Kông Chro', 'Krông Pa', 'Mang Yang'],
    'Hà Giang': ['Hà Giang', 'Đồng Văn', 'Mèo Vạc', 'Yên Minh', 'Quản Bạ', 'Vị Xuyên', 'Bắc Mê', 'Hoàng Su Phì', 'Xín Mần', 'Bắc Quang', 'Quang Bình'],
    'Hà Nam': ['Phủ Lý', 'Duy Tiên', 'Kim Bảng', 'Lý Nhân', 'Thanh Liêm'],
    'Hà Tĩnh': ['Hà Tĩnh', 'Hồng Lĩnh', 'Cẩm Xuyên', 'Can Lộc', 'Đức Thọ', 'Hương Khê', 'Hương Sơn', 'Kỳ Anh', 'Lộc Hà', 'Nghi Xuân', 'Thạch Hà', 'Vũ Quang'],
    'Hải Dương': ['Hải Dương', 'Chí Linh', 'Bình Giang', 'Cẩm Giàng', 'Gia Lộc', 'Kim Thành', 'Kinh Môn', 'Nam Sách', 'Ninh Giang', 'Tứ Kỳ', 'Thanh Hà', 'Thanh Miện'],
    'Hậu Giang': ['Vị Thanh', 'Ngã Bảy', 'Châu Thành', 'Châu Thành A', 'Long Mỹ', 'Phụng Hiệp', 'Vị Thủy'],
    'Hòa Bình': ['Hòa Bình', 'Cao Phong', 'Đà Bắc', 'Kim Bôi', 'Lạc Sơn', 'Lạc Thủy', 'Mai Châu', 'Tân Lạc', 'Yên Thủy'],
    'Hưng Yên': ['Hưng Yên', 'Mỹ Hào', 'Phù Cừ', 'Tiên Lữ', 'Văn Giang', 'Văn Lâm', 'Yên Mỹ'],
    'Khánh Hòa': ['Nha Trang', 'Cam Lâm', 'Cam Ranh', 'Diên Khánh', 'Khánh Sơn', 'Khánh Vĩnh', 'Ninh Hòa', 'Trường Sa', 'Vạn Ninh'],
    'Kiên Giang': ['Rạch Giá', 'Hà Tiên', 'An Biên', 'An Minh', 'Châu Thành', 'Giồng Riềng', 'Gò Quao', 'Hòn Đất', 'Kiên Hải', 'Phú Quốc', 'Rạch Giá', 'Tân Hiệp', 'U Minh Thượng', 'Vĩnh Thuận'],
    'Kon Tum': ['Kon Tum', 'Đắk Glei', 'Đắk Hà', 'Đắk Tô', 'Kon Plông', 'Kon Rẫy', 'Ngọc Hồi', 'Sa Thầy', 'Tu Mơ Rông'],
    'Lai Châu': ['Lai Châu', 'Mường Tè', 'Nậm Nhùn', 'Phong Thổ', 'Sìn Hồ', 'Tam Đường', 'Than Uyên', 'Tả Phìn'],
    'Lâm Đồng': ['Đà Lạt', 'Bảo Lộc', 'Bảo Lâm', 'Cát Tiên', 'Đạ Huoai', 'Đà Tẻh', 'Đam Rông', 'Di Linh', 'Đơn Dương', 'Lạc Dương', 'Lâm Hà'],
    'Lạng Sơn': ['Lạng Sơn', 'Bắc Sơn', 'Bình Gia', 'Cao Lộc', 'Chi Lăng', 'Đình Lập', 'Hữu Lũng', 'Lộc Bình', 'Tràng Định', 'Văn Lãng', 'Văn Quan'],
    'Lào Cai': ['Lào Cai', 'Bát Xát', 'Mường Khương', 'Sa Pa', 'Si Ma Cai', 'Văn Bàn', 'Bảo Thắng', 'Bảo Yên', 'Than Uyên'],
    'Long An': ['Tân An', 'Bến Lức', 'Cần Đước', 'Cần Giuộc', 'Châu Thành', 'Đức Hòa', 'Đức Huệ', 'Mộc Hóa', 'Tân Hưng', 'Tân Thạnh', 'Tân Trụ', 'Thạnh Hóa', 'Thuận An', 'Vĩnh Hưng'],
    'Nam Định': ['Nam Định', 'Giao Thủy', 'Hải Hậu', 'Mỹ Lộc', 'Nam Trực', 'Nghĩa Hưng', 'Trực Ninh', 'Vụ Bản', 'Xuân Trường', 'Ý Yên'],
    'Nghệ An': ['Vinh', 'Cửa Lò', 'Anh Sơn', 'Con Cuông', 'Diễn Châu', 'Đô Lương', 'Hưng Nguyên', 'Kỳ Sơn', 'Nam Đàn', 'Nghi Lộc', 'Quế Phong', 'Quỳ Châu', 'Quỳ Hợp', 'Quỳnh Lưu', 'Tân Kỳ', 'Thanh Chương', 'Tương Dương', 'Yên Thành'],
    'Ninh Bình': ['Ninh Bình', 'Tam Điệp', 'Gia Viễn', 'Hoa Lư', 'Kim Sơn', 'Nho Quan', 'Yên Khánh', 'Yên Mô'],
    'Ninh Thuận': ['Phan Rang - Tháp Chàm', 'Bác Ái', 'Ninh Hải', 'Ninh Phước', 'Thuận Bắc', 'Thuận Nam'],
    'Phú Thọ': ['Việt Trì', 'Phú Thọ', 'Cẩm Khê', 'Đoan Hùng', 'Hạ Hòa', 'Lâm Thao', 'Phù Ninh', 'Tam Nông', 'Tân Sơn', 'Thanh Ba', 'Thanh Sơn', 'Yên Lập'],
    'Phú Yên': ['Tuy Hòa', 'Đông Hòa', 'Sông Cầu', 'Tuy An', 'Đồng Xuân', 'Sơn Hòa', 'Tây Hòa', 'Phú Hòa'],
    'Quảng Bình': ['Đồng Hới', 'Bố Trạch', 'Lệ Thủy', 'Minh Hóa', 'Quảng Ninh', 'Quảng Trạch', 'Tuyên Hóa'],
    'Quảng Nam': ['Tam Kỳ', 'Hội An', 'Điện Bàn', 'Đại Lộc', 'Duy Xuyên', 'Hiệp Đức', 'Nam Giang', 'Nông Sơn', 'Phú Ninh', 'Quế Sơn', 'Tây Giang', 'Thăng Bình', 'Tiên Phước', 'Bắc Trà My', 'Nam Trà My', 'Núi Thành'],
    'Quảng Ngãi': ['Quảng Ngãi', 'Bình Sơn', 'Đức Phổ', 'Mộ Đức', 'Nghĩa Hành', 'Sơn Hà', 'Sơn Tây', 'Sơn Tịnh', 'Tây Trà', 'Trà Bồng', 'Ba Tơ'],
    'Quảng Ninh': ['Hạ Long', 'Móng Cái', 'Uông Bí', 'Cẩm Phả', 'Bình Liêu', 'Đầm Hà', 'Hải Hà', 'Tiên Yên', 'Ba Chẽ', 'Cô Tô'],
    'Quảng Trị': ['Đông Hà', 'Quảng Trị', 'Cam Lộ', 'Cồn Cỏ', 'Đa Krông', 'Gio Linh', 'Hải Lăng', 'Hướng Hóa', 'Triệu Phong', 'Vĩnh Linh'],
    'Sóc Trăng': ['Sóc Trăng', 'Châu Thành', 'Cù Lao Dung', 'Kế Sách', 'Long Phú', 'Mỹ Tú', 'Mỹ Xuyên', 'Ngã Năm', 'Thạnh Trị', 'Vĩnh Châu'],
    'Sơn La': ['Sơn La', 'Mộc Châu', 'Mai Sơn', 'Mường La', 'Phù Yên', 'Quỳnh Nhai', 'Sông Mã', 'Thuận Châu', 'Yên Châu'],
    'Tây Ninh': ['Tây Ninh', 'Bến Cầu', 'Châu Thành', 'Dương Minh Châu', 'Gò Dầu', 'Hòa Thành', 'Tân Biên', 'Tân Châu', 'Trảng Bàng'],
    'Thái Bình': ['Thái Bình', 'Đông Hưng', 'Hưng Hà', 'Kiến Xương', 'Quỳnh Phụ', 'Thái Thụy', 'Tiền Hải', 'Vũ Thư'],
    'Thái Nguyên': ['Thái Nguyên', 'Định Hóa', 'Đồng Hỷ', 'Phú Bình', 'Phú Lương', 'Võ Nhai', 'Sông Công'],
    'Thanh Hóa': ['Thanh Hóa', 'Bỉm Sơn', 'Sầm Sơn', 'Bá Thước', 'Cẩm Thủy', 'Đông Sơn', 'Hà Trung', 'Hậu Lộc', 'Hoằng Hóa', 'Lang Chánh', 'Mường Lát', 'Nga Sơn', 'Ngọc Lặc', 'Như Thanh', 'Như Xuân', 'Nông Cống', 'Quan Hóa', 'Quan Sơn', 'Quảng Xương', 'Thạch Thành', 'Thiệu Hóa', 'Thọ Xuân', 'Tĩnh Gia', 'Triệu Sơn', 'Vĩnh Lộc', 'Yên Định'],
    'Thừa Thiên Huế': ['Huế', 'A Lưới', 'Phong Điền', 'Phú Lộc', 'Phú Vang', 'Quảng Điền', 'Nam Đông'],
    'Tiền Giang': ['Mỹ Tho', 'Gò Công', 'Cai Lậy', 'Châu Thành', 'Chợ Gạo', 'Gò Công Đông', 'Gò Công Tây', 'Tân Phú Đông', 'Tân Phước'],
    'Trà Vinh': ['Trà Vinh', 'Càng Long', 'Cầu Kè', 'Châu Thành', 'Duyên Hải', 'Tiểu Cần', 'Trà Cú'],
    'Tuyên Quang': ['Tuyên Quang', 'Chiêm Hóa', 'Hàm Yên', 'Lâm Bình', 'Na Hang', 'Sơn Dương', 'Yên Sơn'],
    'Vĩnh Long': ['Vĩnh Long', 'Bình Minh', 'Long Hồ', 'Mang Thít', 'Tam Bình', 'Trà Ôn', 'Vũng Liêm'],
    'Vĩnh Phúc': ['Vĩnh Yên', 'Phúc Yên', 'Bình Xuyên', 'Lập Thạch', 'Sông Lô', 'Tam Đảo', 'Tam Dương', 'Yên Lạc'],
    'Yên Bái': ['Yên Bái', 'Nghĩa Lộ', 'Lục Yên', 'Mù Cang Chải', 'Trạm Tấu', 'Trấn Yên', 'Văn Chấn', 'Yên Bình'],
    'Phú Quốc': ['Phú Quốc', 'Kiên Lương', 'Hà Tiên'],
  };

  String selectedCity = 'Tây Ninh';
  String selectedDistrict = 'Tân Châu';
  String homeAddress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Container(
          margin: EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 28, color: Colors.black87),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserDetailPage()),
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        title: Text(
          'Chọn vị trí',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/map_pin.png',
                height: 150,
              ),
              SizedBox(height: 30),

              // Tiêu đề lớn hơn, dễ đọc hơn
              Text(
                'Chọn vị trí của bạn',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 15),

              Text(
                'Vui lòng chọn tỉnh/thành phố và quận/huyện\nnơi bạn đang sinh sống',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tỉnh/Thành phố',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectedCity,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 28,
                        color: Colors.grey[600],
                      ),
                      items: cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(city),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue!;
                          selectedDistrict = districts[selectedCity]?[0] ?? '';
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quận/Huyện',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectedDistrict,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 28,
                        color: Colors.grey[600],
                      ),
                      items: districts[selectedCity]?.map((String district) {
                        return DropdownMenuItem<String>(
                          value: district,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(district),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDistrict = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Địa chỉ nhà (tùy chọn)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Ví dụ: 123 Đường Nguyễn Văn A',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                      ),
                      onChanged: (value) => homeAddress = value,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 50),

              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã chọn vị trí: $selectedCity - $selectedDistrict',
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Xác nhận vị trí',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Thông tin vị trí giúp chúng tôi cung cấp dịch vụ tốt hơn cho bạn',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[800],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}