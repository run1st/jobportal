import 'emp_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'posted_jobs.dart';
import 'notification.dart';
import 'candidates.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final List<Map<String, dynamic>> _pages = [
    {'page': EmpHomePage(), 'title': Text('home')},
    {'page': Posted_jobs(), 'title': Text('jobs posted')},
    {'page': candidates(), 'title': Text('candidates')},
    {'page': EmpNotification(), 'title': Text('Notification')}
  ];
  int selecetedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      selecetedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _pages[selecetedPageIndex]['title'],
      ),
      body: _pages[selecetedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          unselectedItemColor: Colors.amber,
          selectedItemColor: Colors.pink,
          currentIndex: selecetedPageIndex,
          type: BottomNavigationBarType.shifting,
          onTap: _selectPage,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.home),
                tooltip: 'Home',
                label: 'home'),
            BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.post_add),
                tooltip: 'job posts',
                label: 'post'),
            BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.people),
                tooltip: 'candidates',
                label: 'candidates'),
            BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.notification_add),
                tooltip: 'notification',
                label: 'not')
          ]),
    );
  }
}
