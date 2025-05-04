import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  // ฟังก์ชันสำหรับเปิด URL
  Future<void> _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'ไม่สามารถเปิดลิงก์ได้';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เส้นทาง'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'เส้นทางรถไฟในประเทศไทย:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // รายการสายรถไฟจาก JSON
            _buildRouteCard('สายสีเขียว: กรุงเทพฯ - นนทบุรี'),
            _buildRouteCard('สายสีเหลือง: ลาดพร้าว - สายไหม'),
            _buildRouteCard('สายสีชมพู: แคราย - มีนบุรี'),
            const SizedBox(height: 16),

            // เพิ่มปุ่มเพื่อดูข้อมูลรายละเอียดของแต่ละสาย
            ElevatedButton(
              onPressed: () {
                // เมื่อกดปุ่มจะเปิดหน้า URL หรือข้อมูลเพิ่มเติม
                _launchURL('https://www.bts.co.th');
              },
              child: const Text('ดูรายละเอียดเกี่ยวกับ BTS'),
            ),
            ElevatedButton(
              onPressed: () {
                _launchURL('https://mrta-yellowline.com/wp/');
              },
              child: const Text('ดูรายละเอียดเกี่ยวกับ MRT Yellow Line'),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างการ์ดเส้นทาง
  Widget _buildRouteCard(String route) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          route,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
