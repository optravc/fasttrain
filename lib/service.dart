import 'package:flutter/material.dart';
import 'servicedetails.dart'; // นำเข้า MapPage

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String? selectedLine;

  final List<String> lines = [
    'Sukhumvit Line',
    'Silom Line',
    'Gold Line',
    'Yellow Line',
    'Pink Line',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แผนที่การเดินรถไฟฟ้า'),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          // เลือกสายรถไฟฟ้า
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เลือกสายรถไฟฟ้า',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedLine,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLine = newValue;
                      });
                    },
                    items: lines.map((String line) {
                      return DropdownMenuItem<String>(
                        value: line,
                        child: Text(
                          line,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedLine != null) {
                        debugPrint("ไปหน้า MapPage ด้วยสาย: $selectedLine");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Servicedetails(selectedLine: selectedLine!),
                          ),
                        );
                      } else {
                        debugPrint("ยังไม่ได้เลือกสาย");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('กรุณาเลือกสายก่อน')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: const Text('แผนที่บริเวณสถานี'),
                  ),
                ],
              ),
            ),
          ),

          // แผนที่รวม
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Image.asset(
                  'images/all_map_train_line.jpg',
                  width: 600,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
