import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Future<List<Map<String, dynamic>>> loadSupportData() async {
    String jsonString = await rootBundle.loadString('assets/data/support_data.json');
    List<dynamic> jsonResponse = jsonDecode(jsonString);
    return jsonResponse.map((data) => data as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ศูนย์ลูกค้าสัมพันธ์'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadSupportData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่พบข้อมูล'));
          } else {
            List<Map<String, dynamic>> supportData = snapshot.data!;
            return ListView.builder(
              itemCount: supportData.length,
              itemBuilder: (context, index) {
                var item = supportData[index];
                return _buildSupportCard(
                  color: item['color'] == 'green'
                      ? Colors.green
                      : item['color'] == 'yellow'
                          ? Colors.yellow
                          : Colors.pink,
                  title: item['title'],
                  company: item['company'],
                  address: item['address'],
                  phone: item['phone'],
                  fax: item['fax'],
                  email: item['email'],
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildSupportCard({
    required Color color,
    required String title,
    required String company,
    required String address,
    required String phone,
    required String fax,
    required String email,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: color,
                decorationThickness: 2,
              ),
            ),
            SizedBox(height: 8),
            Text('บริษัท: $company', style: TextStyle(fontSize: 16)),
            Text('ที่อยู่: $address', style: TextStyle(fontSize: 16)),
            Text(phone, style: TextStyle(fontSize: 16)),
            Text(fax, style: TextStyle(fontSize: 16)),
            Text(email, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
