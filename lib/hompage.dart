import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project1/job_seeker_home_page/jobSeekerHome.dart';
import 'package:project1/profile/personal_info.dart';
import 'package:project1/profile/tim_line_wraper.dart';
import 'package:project1/user_account/auth_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool fillProfile = false;

  bool personalInfoSection = false;

  bool educationSection = false;

  bool experienceSection = false;

  bool skillSection = false;

  String? currentUser;
  Map<String, dynamic>? otherData;
  Map<String, dynamic>? personalInfo;
  Map<String, dynamic>? skills;
  Map<String, dynamic>? experience;
  Map<String, dynamic>? education;
  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
        });
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Hulu jobs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: currentUser != null
                    ? FirebaseFirestore.instance
                        .collection('job-seeker')
                        .doc(currentUser)
                        .collection('jobseeker-profile')
                        .doc('profile')
                        .snapshots()
                    : null,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData || snapshot.data!.exists) {
                    otherData = snapshot.data!.data()?['other-data']
                        as Map<String, dynamic>?;
                    personalInfo = snapshot.data!.data()?['personal-info']
                        as Map<String, dynamic>?;

                    skills = snapshot.data!.data()?['skills']
                        as Map<String, dynamic>?;
                    final List<dynamic>? languageSkills =
                        snapshot.data!.data()?['skills'] ??
                            {}['language skills'] ??
                            [];
                    final List<dynamic>? personalSkills =
                        snapshot.data!.data()?['skills'] ??
                            {}['personal skills'] ??
                            [];
                    final List<dynamic>? professionalSkills =
                        snapshot.data!.data()?['skills'] ??
                            {}['professional skills'] ??
                            [];
                    experience = snapshot.data!.data()?['experiences'] ??
                        {}['experience'] as Map<String, dynamic>?;
                    education = snapshot.data!.data()?['education']
                        as Map<String, dynamic>?;

                    return SizedBox();
                  } else {}
                  return SizedBox();
                }),
            Image.asset(
              'assets/images/logo.jpg',
              width: MediaQuery.of(context).size.width,
              height: 200,
            ),
            // SizedBox(
            //   height: 20.0,
            // ),
            Text(
              'Welcome  ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Find your dream job here. Build your profile and get started',
                style: TextStyle(color: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: (MediaQuery.of(context).size.width) * 1 / 2,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(home.routeName);
                  },
                  icon: Icon(
                    Icons.home,
                    size: 36,
                  ),
                  label: Text('Go home')),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: (MediaQuery.of(context).size.width) * 1 / 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  onPressed: () {
                    setState(() {
                      fillProfile = !fillProfile;
                    });
                  },
                  child: Text('Build profile')),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: fillProfile ? 500 : 0,
              width: MediaQuery.of(context).size.width - 40,
              color: Colors.white,
              child: Visibility(
                child: MyTimeLineWrapper(
                  personal: personalInfoSection =
                      personalInfo?.isNotEmpty ?? false,
                  education: educationSection = education?.isNotEmpty ?? false,
                  experience: experienceSection =
                      experience?.isNotEmpty ?? false,
                  skills: skillSection = skills?.isNotEmpty ?? false,
                ),
                visible: fillProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
