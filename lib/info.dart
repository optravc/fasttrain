import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  // ฟังก์ชันเปิดลิงก์ ใช้ LaunchMode.externalApplication เพื่อให้ทำงานบน Android API 30+ และ Emulator ได้
  Future<void> _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url, mode: LaunchMode.externalApplication); // ใช้ externalApplication เพื่อความเข้ากันได้
    } else {
      throw 'ไม่สามารถเปิดลิงก์ได้';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข่าวสาร'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNewsCard(
              context,
              'ข่าวรถไฟสายสีเหลือง',
              'https://www.ebm.co.th/',
            ),
            _buildNewsCard(
              context,
              'ข่าวรถไฟสายสีชมพู',
              'https://www.prachachat.net/tag/%E0%B8%A3%E0%B8%96%E0%B9%84%E0%B8%9F%E0%B8%9F%E0%B8%9A%E0%B8%B0%E0%B8%AA%E0%B8%B2%E0%B8%A2%E0%B8%AA%E0%B8%B5%E0%B8%8A%E0%B8%A1%E0%B8%9E%E0%B8%B9',
            ),
          ],
        ),
      ),
    );
  }

  // Card ที่ใช้แสดงข่าวและลิงก์
  Widget _buildNewsCard(BuildContext context, String title, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
