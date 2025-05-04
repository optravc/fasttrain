import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PromotionDetailPage.dart';

class PromotionPage extends StatelessWidget {
  const PromotionPage({super.key});

  Future<List<dynamic>> loadPromotions() async {
    final jsonString = await rootBundle.loadString('assets/data/promotions.json');
    return json.decode(jsonString);
  }

  void navigateToDetail(BuildContext context, Map<String, dynamic> promo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PromotionDetailPage(promo: promo),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 60),
      );
    } else {
      return Image.asset(
        path,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 60),
      );
    }
  }

  Widget buildPromoCard({
    required BuildContext context,
    required Map<String, dynamic> promo,
  }) {
    final double cardWidth = MediaQuery.of(context).size.width / 2 - 24;

    return GestureDetector(
      onTap: () => navigateToDetail(context, promo),
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: _buildImage(promo['image'] ?? ''),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                promo['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 16, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรโมชั่น', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: loadPromotions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่มีข้อมูล'));
          } else {
            final promotions = snapshot.data!;
            final grouped = <String, List<Map<String, dynamic>>>{};

            for (var promo in promotions) {
              final line = promo['line'] ?? 'ไม่ระบุสาย';
              grouped.putIfAbsent(line, () => []).add(promo);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: grouped.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle(entry.key),
                      Wrap(
                        children: entry.value.map((promo) {
                          return buildPromoCard(context: context, promo: promo);
                        }).toList(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
