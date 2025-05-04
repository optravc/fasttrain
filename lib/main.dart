import 'package:flutter/material.dart';
import 'tab_menu.dart';  // นำเข้า TabMenu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Train',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainPage(), // แสดงหน้า MainPage เป็นหน้าแรกของแอป
    );
  }
}

// คลาส MainPage ที่เป็นหน้าแรกของแอป
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // เมื่อหน้า MainPage ถูกโหลด ให้ไปที่ TabMenu
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabMenu()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fast Train'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // แสดงรูปภาพจาก assets
            Image.asset('assets/images/Fast_Train.png', width: 250), // กำหนดขนาดรูป
            const SizedBox(height: 20), // เพิ่มระยะห่างระหว่างรูปและข้อความ
            const Text(
              'ยินดีต้อนรับสู่ Fast Train',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
