import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/job_seeker_home_page/image_card.dart';
import 'package:project1/profile/tim_line_wraper.dart';
import 'package:project1/profile/updateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/user_profile';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool personalInfoSection = false;
  bool educationSection = false;
  bool experienceSection = false;
  bool skillSection = false;
  File? _image;
  List<Map<String, dynamic>> profData = [];
  bool addProfile = false;
  String? currentUser;

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
    await isSectionCompleted(currentUser, '');
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  Future<void> isSectionCompleted(String? id, String section) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) return;

    final state = await getFavState("Personal_$id");
    setState(() {
      personalInfoSection = state ?? false; // Provide a default value if null
      educationSection = prefs.containsKey('Education_$id');
      experienceSection = prefs.containsKey('Experience_$id');
      skillSection = prefs.containsKey('Skills_$id');
    });
  }

  static Future<dynamic> getFavState(String key) async {
    final SharedPreferences prefs2 = await SharedPreferences.getInstance();
    return prefs2.get(key) ?? false; // Provide a default value if null
  }

  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    if (currentUser == null) {
                      return const Center(child: Text('User is not logged in'));
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 50,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              const Text.rich(
                                TextSpan(children: [
                                  TextSpan(text: 'There is no'),
                                  TextSpan(
                                    text: '  Profile Data ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ]),
                              ),
                              const Center(
                                child: ImageCard(
                                  imagePath: 'assets/images/noData3.jpg',
                                  imageCaption: "You haven't tell us about you",
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: MediaQuery.of(context).size.width - 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      addProfile = !addProfile;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide.none,
                                    ),
                                  ),
                                  child: const Text('ADD PROFILE'),
                                ),
                              ),
                              Container(
                                height: addProfile ? 400 : 0,
                                width: MediaQuery.of(context).size.width - 40,
                                color: Colors.white,
                                child: Visibility(
                                  child: MyTimeLineWrapper(
                                    personal: personalInfoSection,
                                    education: educationSection,
                                    experience: experienceSection,
                                    skills: skillSection,
                                  ),
                                  visible: addProfile,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }

                  Map<String, dynamic>? otherData = snapshot.data!
                      .data()?['other-data'] as Map<String, dynamic>?;
                  Map<String, dynamic>? personalInfo = snapshot.data!
                      .data()?['personal-info'] as Map<String, dynamic>?;

                  Map<String, dynamic>? skills =
                      snapshot.data!.data()?['skills'] as Map<String, dynamic>?;
                  final List<dynamic>? languageSkills =
                      skills?['language skills'] as List<dynamic>?;
                  final List<dynamic>? personalSkills =
                      skills?['personal skills'] as List<dynamic>?;
                  final List<dynamic>? professionalSkills =
                      skills?['professional skills'] as List<dynamic>?;
                  Map<String, dynamic>? experience =
                      snapshot.data!.data()?['experiences'] ??
                          {}['experience'] as Map<String, dynamic>?;
                  Map<String, dynamic>? education = snapshot.data!
                      .data()?['education'] as Map<String, dynamic>?;

                  String startDate = experience?['startDte'] != null
                      ? formatTimestamp(experience?['startDte'])
                      : 'No start date';
                  String finalDate = experience?['End date'] != null
                      ? formatTimestamp(experience?['End date'])
                      : 'No end date';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 50),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: CircleAvatar(
                              backgroundImage: otherData?['profile image'] !=
                                      null
                                  ? NetworkImage(otherData!['profile image'])
                                  : AssetImage('assets/images/logo.jpeg')
                                      as ImageProvider,
                              radius: 50,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          '  ${personalInfo?['first name'] ?? ''} ${personalInfo?['last name'] ?? ''}',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      education?['institution']?.isEmpty ?? true
                          ? SizedBox()
                          : Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  child: Text(
                                      '${education?['institution'] ?? ''}'),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit, color: Colors.grey),
                                ),
                              ],
                            ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            child: Text(
                                '${education?['levelOfEducation'] ?? ''} in ${education?['fieldOfStudy'] ?? ''}'),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(onPressed: () {}, child: Text('Edit')),
                          //  DownloadCv(),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Experience',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            ListTile(
                              title: Text(experience?['job title'] ?? ''),
                              subtitle: Text(
                                  '${experience?['company'] ?? ''}, $startDate - $finalDate'),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.edit),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Front-end Developer'),
                              subtitle: Text('XYZ Inc., Sep 2018 - Dec 2019'),
                              trailing: Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Education',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              UpdateEducationDialog(),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              UpdateEducationDialog(),
                                        );
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            ListTile(
                              title: Text(
                                  'Bachelor in ${education?['fieldOfStudy'] ?? ''}'),
                              subtitle: Text(
                                  'University of ABC, Sep 2014 - May 2018'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Professional skills',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text('Add'),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  UpdateSkillsDialog(
                                                      skill_Type:
                                                          'professional skills'),
                                            );
                                          },
                                          icon: Icon(Icons.add,
                                              color: Colors.amber),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                professionalSkills!.isEmpty
                                    ? SizedBox()
                                    : Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: [
                                          ...professionalSkills.map(
                                            (skill) => Chip(
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              backgroundColor: Color.fromARGB(
                                                  255, 22, 125, 209),
                                              deleteIconColor: Colors.yellow,
                                              label: Text(skill),
                                              onDeleted: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Personal skills',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text('Add'),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      UpdateSkillsDialog(
                                                          skill_Type:
                                                              'personal skills'),
                                                );
                                              },
                                              icon: Icon(Icons.add,
                                                  color: Colors.amber),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    personalSkills!.isEmpty
                                        ? SizedBox()
                                        : Wrap(
                                            spacing: 8.0,
                                            runSpacing: 4.0,
                                            children: [
                                              ...personalSkills.map(
                                                (skill) => Chip(
                                                  deleteIconColor: Colors.red,
                                                  label: Text(skill),
                                                  onDeleted: () {},
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Language skills',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Text('Add'),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    UpdateSkillsDialog(
                                                        skill_Type:
                                                            'language skills'),
                                              );
                                            },
                                            icon: Icon(Icons.add,
                                                color: Colors.amber),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                languageSkills!.isEmpty
                                    ? SizedBox()
                                    : Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: [
                                          ...languageSkills.map(
                                            (skill) => Chip(
                                              backgroundColor: Color.fromARGB(
                                                  255, 48, 214, 226),
                                              deleteIconColor: Colors.red,
                                              label: Text(skill),
                                              onDeleted: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width - 150,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                addProfile = !addProfile;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide.none,
                              ),
                            ),
                            child: const Text('Profile Completeness'),
                          ),
                        ),
                      ),
                      Container(
                        height: addProfile ? 400 : 0,
                        width: MediaQuery.of(context).size.width - 40,
                        color: Colors.white,
                        child: Visibility(
                          child: MyTimeLineWrapper(
                            personal: personalInfoSection =
                                personalInfo?.isNotEmpty ?? false,
                            education: educationSection =
                                education?.isNotEmpty ?? false,
                            experience: experienceSection =
                                experience?.isNotEmpty ?? false,
                            skills: skillSection = skills?.isNotEmpty ?? false,
                          ),
                          visible: addProfile,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
