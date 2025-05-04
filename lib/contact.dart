import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<List<Map<String, dynamic>>> loadContactData() async {
    String jsonString = await rootBundle.loadString('assets/data/contact_data.json');
    List<dynamic> jsonResponse = jsonDecode(jsonString);
    return jsonResponse.map((data) => data as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ติดต่อเรา'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadContactData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่พบข้อมูล'));
          } else {
            List<Map<String, dynamic>> contactData = snapshot.data!;
            return ListView.builder(
              itemCount: contactData.length,
              itemBuilder: (context, index) {
                var item = contactData[index];
                return _buildContactCard(
                  color: item['color'] == 'green'
                      ? Colors.green
                      : item['color'] == 'yellow'
                          ? Colors.yellow
                          : Colors.pink,
                  title: item['title'],
                  website: item['website'],
                  facebook: item['facebook'],
                  twitter: item['twitter'],
                  line: item['line'],
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildContactCard({
    required Color color,
    required String title,
    required String website,
    required String facebook,
    required String twitter,
    required String line,
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
            _buildSocialMediaRow('เว็บไซต์', website),
            Divider(thickness: 1, color: Colors.grey),
            _buildSocialMediaRow('Facebook', facebook),
            Divider(thickness: 1, color: Colors.grey),
            _buildSocialMediaRow('Twitter', twitter),
            Divider(thickness: 1, color: Colors.grey),
            _buildSocialMediaRow('Line', line),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaRow(String label, String link) {
    return GestureDetector(
      onTap: () => _launchURL(link),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            '$label: $link',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'ไม่สามารถเปิดลิงก์: $url';
    }
  }
}
