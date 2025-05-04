import 'package:flutter/material.dart';
import 'train.dart';
import 'promotion.dart';  // นำเข้า PromotionPage
import 'info.dart';       // นำเข้า InfoPage
import 'service.dart';    // นำเข้า ServicePage
import 'other.dart';      // นำเข้า OtherPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ชื่อแอปของคุณ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TabMenu(), // เรียกใช้ TabMenu เป็นหน้าแรก
    );
  }
}

class TabMenu extends StatefulWidget {
  const TabMenu({super.key});

  @override
  _TabMenuState createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> {
  int _selectedIndex = 0;

  // ฟังก์ชันเพื่อสลับหน้าเมื่อคลิกแท็บ
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // รายการหน้าต่างๆ สำหรับแต่ละแท็บ
  final List<Widget> _pages = [
    const TrainPage(), // เปลี่ยนเป็นหน้า TrainPage
    const PromotionPage(), // หน้าโปรโมชั่น
    const InfoPage(),     // หน้าข่าวสาร
    const ServicePage(),  // หน้าบริการ
    const OtherPage(),    // หน้าเพิ่มเติม
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // สีของ AppBar เป็นน้ำเงิน
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/Fast_Train01.png', height: 80,  // ปรับขนาดให้ใหญ่ขึ้น
            fit: BoxFit.contain,), // เปลี่ยนเป็นรูปที่คุณต้องการ
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex, // ใช้ index เพื่อเลือกหน้า
        children: _pages, // รายการหน้าทั้งหมด
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,  // เมื่อคลิกแท็บให้เปลี่ยนหน้า
        selectedItemColor: Colors.blueAccent, // สีของแท็บที่เลือก
        unselectedItemColor: Colors.blue[300], // สีของแท็บที่ไม่ได้เลือก
        backgroundColor: Colors.blue, // พื้นหลังของ BottomNavigationBar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'เส้นทาง',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'โปรโมชั่น',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'ข่าวสาร',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.train),
            label: 'แผนที่',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'ดูเพิ่มเติม',
          ),
        ],
      ),
    );
  }
}
