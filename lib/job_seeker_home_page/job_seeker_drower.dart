import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project1/job_seeker_home_page/applied_jobs.dart';
import 'package:project1/job_seeker_home_page/jobSeekerSetting.dart';
import 'package:project1/user_account/auth_page.dart';
import 'package:project1/user_account/rgister.dart';

import '../profile/job_seeker_profile.dart';

class Drower extends StatefulWidget {
  const Drower({Key? key}) : super(key: key);

  @override
  State<Drower> createState() => _DrowerState();
}

class _DrowerState extends State<Drower> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? currentUserData;
  String? currentUser;
  String? currentUemail;
  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
        });

        final currentUserDataRef = FirebaseFirestore.instance
            .collection('job-seeker')
            .doc(currentUser);

        final currentUserData = await currentUserDataRef.get();

        if (currentUserData.exists) {
          setState(() {
            currentUemail = currentUserData['email'];
          });
        }
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    print('the current user id is ${currentUser}');
    return Container(
      height: MediaQuery.of(context).size.height - 500,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: currentUemail == null
                ? Text("No Email Found")
                : Text('${currentUemail?.trim()}'),
            accountEmail: currentUemail == null
                ? Text("No Email Found")
                : Text('${currentUemail?.trim()}'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: currentUemail == null
                  ? Text(
                      "",
                      style: TextStyle(fontSize: 28),
                    )
                  : Text(
                      '${currentUemail?.substring(0, 2).toUpperCase()}',
                      style: TextStyle(fontSize: 28),
                    ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("My Profile"),
            //  onTap: () {},

            onTap: () {
              Navigator.pop(context); // Close the drawer

              if (currentUser != 'null') {
                Navigator.pushNamed(context, ProfilePage.routeName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please sign up first.'),
                    action: SnackBarAction(
                      label: 'Sign Up',
                      onPressed: () {
                        // Handle the sign-up action
                        // Navigate to the sign-up page or perform any other necessary actions
                      },
                    ),
                  ),
                );
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.work),
            title: Text("Applied Jobs"),
            onTap: () {
              if (currentUser != 'null') {
                Navigator.pushNamed(context, Applied_jobs_list.routeName);
              }
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.notifications),
          //   title: Text("Job Alerts"),
          //   onTap: () {
          //     if (currentUser != 'null') {}
          //   },
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              if (currentUser != 'null') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppSettings()),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help & Support"),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, AuthPage.routName,
                  arguments: AuthPage(isLogin: true));
            },
          ),
        ],
      ),
    );
  }
}
