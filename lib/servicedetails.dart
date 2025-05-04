import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'price.dart';
import 'config.dart';

class Servicedetails extends StatefulWidget {
  final String selectedLine;

  const Servicedetails({super.key, required this.selectedLine});

  @override
  _ServicedetailsState createState() => _ServicedetailsState();
}

class _ServicedetailsState extends State<Servicedetails> {
  String? selectedStartStation;
  String? selectedEndStation;
  double price = 0.0;
  Map<String, dynamic>? data;

  final String baseUrl = apiUrl;

  Future<void> loadData() async {
    try {
     final fullUrl = '$baseUrl/api/stations';
      print('📡 เรียก URL: $fullUrl');

      final response = await http.get(Uri.parse(fullUrl));
      print('📦 status: ${response.statusCode}');
      print('📄 body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          data = decoded;
        });
      } else {
        throw Exception('โหลดข้อมูลไม่สำเร็จ');
      }
    } catch (e) {
      debugPrint('❌ error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final lineData = data![widget.selectedLine];
    final stations = List<String>.from(lineData['stations']);
    final mapUrl = lineData['map_url']; // ✅ ต้องใช้ map_url (ไม่ใช่ submap)

    return Scaffold(
      appBar: AppBar(title: Text('สาย: ${widget.selectedLine}')),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    hint: const Text('เลือกสถานีต้นทาง'),
                    value: selectedStartStation,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        selectedStartStation = value;
                        if (selectedEndStation != null) {
                          price = calculatePrice(
                            stations,
                            selectedStartStation!,
                            selectedEndStation!,
                            widget.selectedLine,
                          );
                        }
                      });
                    },
                    items: stations.map((station) {
                      return DropdownMenuItem<String>(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    hint: const Text('เลือกสถานีปลายทาง'),
                    value: selectedEndStation,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        selectedEndStation = value;
                        if (selectedStartStation != null) {
                          price = calculatePrice(
                            stations,
                            selectedStartStation!,
                            selectedEndStation!,
                            widget.selectedLine,
                          );
                        }
                      });
                    },
                    items: stations.map((station) {
                      return DropdownMenuItem<String>(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'ราคาตั๋ว: ฿${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: mapUrl != null
                  ? Image.network(
                      mapUrl,
                      width: 600,
                      height: 400,
                      fit: BoxFit.contain,
                    )
                  : const Center(child: Text('ไม่มีแผนที่')),
            ),
          ),
        ],
      ),
    );
  }
}
