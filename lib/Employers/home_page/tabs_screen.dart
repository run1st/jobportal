import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/Employers/home_page/menuButton.dart';
import 'package:project1/hompage.dart';
import 'emp_home_page.dart';
import 'package:flutter/material.dart';
import 'posted_jobs.dart';
import 'notification.dart';
import 'candidates.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/TabsScreen';
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String? logoUrl;
  String currentUser = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
        });
        fetchLogoUrl();
      } else {
        print('No user is signed in.');
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  Future<void> fetchLogoUrl() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('employer')
              .doc(currentUser)
              .collection('company profile')
              .doc('profile')
              .get();

      if (documentSnapshot.exists) {
        setState(() {
          logoUrl = documentSnapshot.data()?['logoUrl'];
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching logoUrl: $e');
    }
  }

  int selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _pages = [
      {
        'page': EmpHomePage(),
        'title': Text('home'),
        'action': CircleAvatar(
          radius: 50,
          backgroundImage: logoUrl != null
              ? NetworkImage(logoUrl!)
              : AssetImage('assets/images/profile2.jpeg') as ImageProvider,
          child: popUpMenu(),
        ),
      },
      {'page': Posted_jobs(), 'title': Text('jobs posted')},
      {'page': candidates(), 'title': Text('candidates')},
      {'page': EmpNotification(), 'title': Text('Notification')}
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _pages[selectedPageIndex]['title'],
        actions: [
          _pages[selectedPageIndex]['action'] ?? Container(),
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: _pages[selectedPageIndex]['page'],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        index: selectedPageIndex,
        onTap: _selectPage,
        items: [
          const CurvedNavigationBarItem(
            child: Icon(Icons.home),
            label: 'home',
          ),
          const CurvedNavigationBarItem(
            child: Icon(Icons.post_add),
            label: 'job posts',
          ),
          const CurvedNavigationBarItem(
            child: Icon(Icons.people),
            label: 'candidates',
          ),
          const CurvedNavigationBarItem(
            child: Icon(Icons.notification_add),
            label: 'not',
          ),
        ],
      ),
    );
  }
}
