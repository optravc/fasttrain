import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // สำหรับเปิดลิงก์

class PromotionDetailPage extends StatelessWidget {
  final Map<String, dynamic> promo;

  const PromotionDetailPage({super.key, required this.promo});

  void _launchLink(BuildContext context) async {
    final Uri url = Uri.parse(promo['link']);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดลิงก์ได้')),
      );
    }
  }
Widget _buildImage(String path) {
  if (path.startsWith('http')) {
    return Image.network(path, height: 200, fit: BoxFit.cover);
  } else {
    return Image.asset(path, height: 200, fit: BoxFit.cover);
  }
}
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(promo['title'] ?? '', style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.pink,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(promo['image'] ?? ''),
          const SizedBox(height: 16),
          if (promo['subtitle'] != null)
            Text(promo['subtitle'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(promo['details'], style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Text('📅 ช่วงเวลา: ${promo['period']}'),
          const SizedBox(height: 8),
          Text('📝 เงื่อนไข: ${promo['terms']}'),
          const SizedBox(height: 16),
          if (promo['link'] != null)
            ElevatedButton.icon(
              onPressed: () => _launchLink(context),
              icon: const Icon(Icons.link),
              label: const Text('ดูรายละเอียดเพิ่มเติม'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            )
        ],
      ),
    ),
  );
}
}