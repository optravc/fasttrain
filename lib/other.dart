import 'package:flutter/material.dart';
import 'support.dart';
import 'contact.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ดูเพิ่มเติม',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ปุ่มแรกที่มีไอคอนและข้อความ
            ElevatedButton.icon(
              onPressed: () {
                // เชื่อมไปยังหน้าติดต่อเรา
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
                );
              },
              icon: Icon(Icons.mail_outline, color: Colors.white),
              label: Text(
                'ติดต่อเรา',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            // ปุ่มที่สองที่มีไอคอนและข้อความ
            ElevatedButton.icon(
              onPressed: () {
                // เชื่อมไปยังหน้าศูนย์ลูกค้าสัมพันธ์
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
              icon: Icon(Icons.headset_mic, color: Colors.white),
              label: Text(
                'ศูนย์ลูกค้าสัมพันธ์',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


