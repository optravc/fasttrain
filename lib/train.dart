import 'package:flutter/material.dart';
import 'traindetails.dart';

class TrainPage extends StatefulWidget {
  const TrainPage({super.key});

  @override
  State<TrainPage> createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  final List<String> lines = ['Sukhumvit Line', 'Silom Line', 'Gold Line'];
  String? selectedLine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกสายรถไฟฟ้า'),
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
                    const Text('เลือกสายรถไฟฟ้า',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('สายรถไฟฟ้า',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedLine,
                items: lines.map((line) {
                  return DropdownMenuItem(value: line, child: Text(line));
                }).toList(),
                onChanged: (line) {
                  setState(() {
                    selectedLine = line;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: selectedLine != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainDetailsPage(
                              line: selectedLine!,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('เส้นทาง'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
