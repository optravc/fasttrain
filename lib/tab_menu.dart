import 'package:flutter/material.dart';
import 'train.dart';
import 'promotion.dart';
import 'service.dart';
import 'other.dart';
import 'AdminAuthPage.dart'; // ✅ นำเข้า

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
      debugShowCheckedModeBanner: false,
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const TrainPage(),
    const PromotionPage(),
    const ServicePage(),
    const OtherPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/Fast_Train01.png',
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'เข้าสู่ระบบแอดมิน',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminAuthPage()),
              );
            },
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blue[300],
        backgroundColor: Colors.blue,
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
