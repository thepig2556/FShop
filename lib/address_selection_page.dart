import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LocationPickerPage(),
    );
  }
}

class LocationPickerPage extends StatefulWidget {
  final String? initialAddress;
  final LatLng? initialLocation;

  const LocationPickerPage({super.key, this.initialAddress, this.initialLocation});

  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final TextEditingController _addressController = TextEditingController();
  final MapController _mapController = MapController();
  LatLng _selectedLocation = const LatLng(10.7769, 106.7009); // Mặc định: TP.HCM
  bool _isLoading = false;
  List<Map<String, dynamic>> _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _addressController.text = widget.initialAddress!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialLocation != null) {
        setState(() {
          _selectedLocation = widget.initialLocation!;
          _mapController.move(_selectedLocation, 14.0);
        });
      }
    });
  }

  // Tìm gợi ý địa chỉ từ Nominatim
  Future<void> _fetchAddressSuggestions(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      if (query.isEmpty) {
        setState(() {
          _suggestions = [];
        });
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query,+Vietnam&format=json&limit=5',
        );
        print('Gửi yêu cầu đến: $url');
        final response = await http.get(
          url,
          headers: {'User-Agent': 'MyFlutterApp/1.0 (https://example.com, support@example.com)'},
        ).timeout(const Duration(seconds: 10));
        print('Phản hồi: ${response.statusCode} - ${response.body}');
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as List;
          setState(() {
            _suggestions = data
                .map((item) => {
              'display_name': item['display_name'],
              'lat': double.parse(item['lat']),
              'lon': double.parse(item['lon']),
            })
                .toList();
          });
        } else {
          _showSnackBar('Lỗi server: ${response.statusCode}');
        }
      } on SocketException catch (e) {
        _showSnackBar('Lỗi kết nối mạng: $e');
      } on TimeoutException catch (e) {
        _showSnackBar('Kết nối timeout: $e');
      } catch (e) {
        _showSnackBar('Lỗi không xác định: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // Tìm tọa độ từ địa chỉ (geocoding)
  Future<void> _geocodeAddress(String address) async {
    if (address.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$address,+Vietnam&format=json&limit=1',
      );
      print('Gửi yêu cầu đến: $url');
      final response = await http.get(
        url,
        headers: {'User-Agent': 'MyFlutterApp/1.0 (https://example.com, support@example.com)'},
      ).timeout(const Duration(seconds: 10));
      print('Phản hồi: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          setState(() {
            _selectedLocation = LatLng(lat, lon);
            _mapController.move(_selectedLocation, 14.0);
          });
        } else {
          _showSnackBar('Không tìm thấy vị trí cho địa chỉ này');
        }
      } else {
        _showSnackBar('Lỗi server: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      _showSnackBar('Lỗi kết nối mạng: $e');
    } on TimeoutException catch (e) {
      _showSnackBar('Kết nối timeout: $e');
    } catch (e) {
      _showSnackBar('Lỗi không xác định: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Tìm địa chỉ từ tọa độ (reverse geocoding)
  Future<void> _reverseGeocode(LatLng point) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${point.latitude}&lon=${point.longitude}&format=json',
      );
      print('Gửi yêu cầu đến: $url');
      final response = await http.get(
        url,
        headers: {'User-Agent': 'MyFlutterApp/1.0 (https://example.com, support@example.com)'},
      ).timeout(const Duration(seconds: 10));
      print('Phản hồi: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['display_name'] ?? 'Không tìm thấy địa chỉ';
        setState(() {
          _addressController.text = address;
          _suggestions = [];
        });
      } else {
        _showSnackBar('Lỗi server: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      _showSnackBar('Lỗi kết nối mạng: $e');
    } on TimeoutException catch (e) {
      _showSnackBar('Kết nối timeout: $e');
    } catch (e) {
      _showSnackBar('Lỗi không xác định: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Chọn gợi ý địa chỉ
  void _selectSuggestion(Map<String, dynamic> suggestion) {
    setState(() {
      _selectedLocation = LatLng(suggestion['lat'], suggestion['lon']);
      _addressController.text = suggestion['display_name'];
      _suggestions = [];
      _mapController.move(_selectedLocation, 14.0);
    });
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
      _mapController.move(_selectedLocation, _mapController.camera.zoom);
    });
    _reverseGeocode(point);
  }

  void _confirmLocation() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      _showSnackBar('Vui lòng nhập hoặc chọn địa chỉ');
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        final url = Uri.parse('https://apitaofood.onrender.com/users/$userId');
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'address': address}),
        ).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          Navigator.pop(context, {
            'address': address,
            'latitude': _selectedLocation.latitude,
            'longitude': _selectedLocation.longitude,
          });
          _showSnackBar('Đã cập nhật địa chỉ: $address');
        } else {
          _showSnackBar('Lỗi khi cập nhật địa chỉ: ${response.statusCode}');
        }
      } on SocketException catch (e) {
        _showSnackBar('Lỗi kết nối mạng: $e');
      } on TimeoutException catch (e) {
        _showSnackBar('Kết nối timeout: $e');
      } catch (e) {
        _showSnackBar('Lỗi không xác định: $e');
      }
    } else {
      _showSnackBar('Không tìm thấy người dùng');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: message.contains('Lỗi') ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _addressController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        title: const Text(
          'Chọn địa chỉ',
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Chọn địa chỉ của bạn',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nhập địa chỉ hoặc chạm vào bản đồ để chọn vị trí',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              // Address Input
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _addressController,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Ví dụ: 123 Nguyễn Văn Cừ, Quận 5, TP.HCM',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    suffixIcon: _isLoading
                        ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : null,
                  ),
                  onChanged: _fetchAddressSuggestions,
                  onSubmitted: _geocodeAddress,
                ),
              ),
              // Address Suggestions
              if (_suggestions.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        title: Text(
                          suggestion['display_name'],
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => _selectSuggestion(suggestion),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              // Map
              Container(
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _selectedLocation,
                      initialZoom: 14.0,
                      minZoom: 6.0,
                      maxZoom: 18.0,
                      onTap: _onMapTap,
                      cameraConstraint: CameraConstraint.contain(
                        bounds: LatLngBounds(
                          const LatLng(8.0, 102.0), // Tây Nam Việt Nam
                          const LatLng(23.5, 109.5), // Đông Bắc Việt Nam
                        ),
                      ),
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Xác nhận địa chỉ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Info Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Thông tin địa chỉ giúp chúng tôi cung cấp dịch vụ tốt hơn',
                        style: TextStyle(
                          fontSize: 14,
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