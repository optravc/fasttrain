import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class Servicedetails extends StatefulWidget {
  final String selectedLine;

  const Servicedetails({super.key, required this.selectedLine});

  @override
  State<Servicedetails> createState() => _ServicedetailsState();
}

class _ServicedetailsState extends State<Servicedetails> {
  String? selectedStartStation;
  List<Map<String, dynamic>> stations = [];

  // โหลดข้อมูลจาก API
Future<void> fetchStations() async {
  final url = Uri.parse('$apiUrl/stations');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // ✅ ป้องกัน key ไม่ตรง (เช่น null)
      if (!data.containsKey(widget.selectedLine)) {
        throw Exception('ไม่พบข้อมูลสาย: ${widget.selectedLine}');
      }

      final lineData = data[widget.selectedLine];
      setState(() {
        stations = List<Map<String, dynamic>>.from(lineData['stations']);
      });
    } else {
      throw Exception('โหลดข้อมูลไม่สำเร็จจาก API');
    }
  } catch (e) {
    debugPrint('❌ โหลดข้อมูลจาก API ไม่สำเร็จ: $e');
  }
}


  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final mapUrl = selectedStartStation != null
        ? stations.firstWhere(
            (s) => s['name'] == selectedStartStation,
            orElse: () => {'map_url': null},
          )['map_url']
        : null;

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
                    isExpanded: true,
                    hint: const Text('เลือกสถานีต้นทาง'),
                    value: selectedStartStation,
                    onChanged: (val) {
                      setState(() {
                        selectedStartStation = val;
                      });
                    },
                    items: stations.map<DropdownMenuItem<String>>((station) {
                      return DropdownMenuItem<String>(
                        value: station['name'],
                        child: Text(station['name']),
                      );
                    }).toList(),
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
