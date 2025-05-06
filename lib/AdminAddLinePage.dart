import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class AdminAddLinePage extends StatefulWidget {
  const AdminAddLinePage({super.key});

  @override
  State<AdminAddLinePage> createState() => _AdminAddLinePageState();
}

class _AdminAddLinePageState extends State<AdminAddLinePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController mapUrl = TextEditingController();

  String? selectedLine;
  bool _loading = false;

  final List<String> lines = ['Sukhumvit Line', 'Gold Line', 'Silom Line'];

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && selectedLine != null) {
      setState(() => _loading = true);

      try {
        final response = await http.post(
          Uri.parse('$apiUrl/addLine'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'line': selectedLine,
            'name': name.text.trim(),
            'map_url': mapUrl.text.trim(),
          }),
        );

        setState(() => _loading = false);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ เพิ่มสถานีเรียบร้อย')),
          );
          name.clear();
          mapUrl.clear();
          setState(() => selectedLine = null);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ ผิดพลาด: ${response.body}')),
          );
        }
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ เชื่อมต่อไม่ได้: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มสถานีรถไฟ'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedLine,
                items: lines.map((line) {
                  return DropdownMenuItem(value: line, child: Text(line));
                }).toList(),
                onChanged: (value) => setState(() => selectedLine = value),
                decoration: const InputDecoration(labelText: 'เลือกสายรถไฟ'),
                validator: (value) => value == null ? 'กรุณาเลือกสายรถไฟ' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'ชื่อสถานี'),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อสถานี' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: mapUrl,
                decoration: const InputDecoration(labelText: 'ลิงก์แผนที่สถานี'),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกลิงก์แผนที่' : null,
              ),
              const SizedBox(height: 30),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text('เพิ่มสถานี'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
