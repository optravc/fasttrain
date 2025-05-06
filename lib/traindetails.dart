import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'config.dart';
import 'price.dart';

class TrainDetailsPage extends StatefulWidget {
  final String line;

  const TrainDetailsPage({super.key, required this.line});

  @override
  State<TrainDetailsPage> createState() => _TrainDetailsPageState();
}

class _TrainDetailsPageState extends State<TrainDetailsPage> {
  List<String> stations = [];
  String? startStation;
  String? endStation;
  bool isLoading = true;
  String? priceMessage;
  double price = 0.0;

  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  Future<void> fetchStations() async {
    final url = Uri.parse('$apiUrl/stations');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> lineStations = data[widget.line]['stations'];
        setState(() {
          stations = lineStations.map<String>((s) => s['name'] as String).toList();
          isLoading = false;
        });
      } else {
        throw Exception('โหลดสถานีไม่สำเร็จ');
      }
    } catch (e) {
      debugPrint('❌ Error loading stations: $e');
      setState(() => isLoading = false);
    }
  }

  void showQRPopup() {
    final ref = '${widget.line}-${DateTime.now().millisecondsSinceEpoch}';
    final qrText = 'https://mock-qr.fasttrain.com/checkout/$ref';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('QR ชำระเงิน'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("สแกน QR เพื่อชำระเงิน"),
              const SizedBox(height: 8),
              Text('$startStation → $endStation',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text('ยอดที่ต้องชำระ: ${price.toStringAsFixed(2)} บาท',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                width: 200,
                height: 200,
                child: QrImageView(
                  data: qrText,
                  size: 200,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  confirmPayment(qrText);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('ยืนยันชำระเงิน'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  Future<void> confirmPayment(String qrText) async {
    final url = Uri.parse('$apiUrl/payment');
    final body = {
      "line": widget.line,
      "startStation": startStation,
      "endStation": endStation,
      "price": price.toString(),
      "qrText": qrText,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ ชำระเงินสำเร็จ')),
        );
      } else {
        throw Exception('บันทึกตั๋วล้มเหลว');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกเส้นทาง - ${widget.line}'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.blue[800],
                child: Row(
                  children: [
                    Container(width: 6, height: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text('เลือกสถานี', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('ต้นทาง'),
              _buildDropdown(
                value: startStation,
                hint: 'เลือกสถานีต้นทาง',
                onChanged: (value) => setState(() => startStation = value),
              ),
              const SizedBox(height: 16),
              _buildLabel('ปลายทาง'),
              _buildDropdown(
                value: endStation,
                hint: 'เลือกสถานีปลายทาง',
                onChanged: (value) => setState(() => endStation = value),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (startStation != null && endStation != null) {
                    final result = calculatePrice(
                      stations,
                      startStation!,
                      endStation!,
                      widget.line,
                    );
                    setState(() {
                      price = result['price'];
                      priceMessage = result['message'];
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('คำนวณค่าโดยสาร'),
              ),
              if (priceMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  priceMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: showQRPopup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('ชำระเงิน'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: stations.map((station) {
            return DropdownMenuItem(value: station, child: Text(station));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
