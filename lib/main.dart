import 'package:flutter/material.dart';
import 'package:zlp_poc/notification/ui/notification_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  final List<Widget> widgetOptions = const [
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Product',
    ),
    Text(
      'Index 2: Orders',
    ),
    NotificationScreen(),
    Text(
      'Index 4: Account',
    ),
  ];

  List<BottomNavigationBarItem> get listBottomItem => [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Product',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined),
          label: 'Orders',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Notifications',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Account',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff234455),
        title: Text(widget.title),
      ),
      body: Center(child: widgetOptions.elementAt(currentIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: listBottomItem,
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
      ),
    );
  }
}
