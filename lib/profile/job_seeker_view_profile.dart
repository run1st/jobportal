import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/job_seeker_home_page/image_card.dart';
import 'package:intl/intl.dart';

class ProfilePageView extends StatefulWidget {
  static const routeName = '/user_profile';
  final String id;
  const ProfilePageView({Key? key, required this.id}) : super(key: key);

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
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
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'No date provided';
    DateTime dateTime = timestamp.toDate();
    return DateFormat("yyyy-MM-dd").format(dateTime);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.id.isNotEmpty
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('job-seeker')
                          .doc(widget.id)
                          .collection('jobseeker-profile')
                          .doc('profile')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (!snapshot.hasData ||
                            !snapshot.data!.exists) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 50,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
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
                                      imageCaption:
                                          "There is no profile data filled by the user",
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: const Text('EMPTY PROFILE'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        Map<String, dynamic>? otherData = snapshot.data!
                            .data()?['other-data'] as Map<String, dynamic>?;
                        Map<String, dynamic>? personalInfo = snapshot.data!
                            .data()?['personal-info'] as Map<String, dynamic>?;

                        Map<String, dynamic>? skills = snapshot.data!
                            .data()?['skills'] as Map<String, dynamic>?;
                        final List<dynamic>? languageSkills =
                            skills?['language skills'] ?? [];
                        final List<dynamic>? personalSkills =
                            skills?['personal skills'] ?? [];
                        final List<dynamic>? professionalSkills =
                            skills?['professional skills'] ?? [];
                        Map<String, dynamic>? experience = snapshot.data!
                            .data()?['experiences'] as Map<String, dynamic>?;
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
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: CircleAvatar(
                                    backgroundImage: otherData?[
                                                'profile image'] !=
                                            null
                                        ? NetworkImage(
                                            otherData!['profile image'])
                                        : AssetImage(
                                                'assets/images/profile2.jpeg')
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
                                '  ${personalInfo?['first name'] ?? 'First Name'} ${personalInfo?['last name'] ?? 'Last Name'}',
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            (education?['institution']?.isEmpty ?? true)
                                ? const SizedBox(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child:
                                            Text('  Institution: Not filled')),
                                  )
                                : Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 4),
                                        child: Text(
                                            '${education?['institution'] ?? ''}'),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  child: Text(
                                      '${education?['levelOfEducation'] ?? ''}  ${education?['fieldOfStudy'] ?? ''}'),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Experience',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ListTile(
                                    title: Text(experience?['job title'] ??
                                        'No prior experience Provided'),
                                    subtitle: Text(
                                        '${experience?['company'] ?? ''}, $startDate - $finalDate'),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Education',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ListTile(
                                    title: (education?['fieldOfStudy'] != null)
                                        ? Text(
                                            'Bachelor in ${education?['fieldOfStudy'] ?? ''}')
                                        : const Text('No Education Data Added'),
                                    subtitle: (education?['fieldOfStudy'] !=
                                            null)
                                        ? Text(
                                            'University of ${education?['institution'] ?? ''}, $startDate - $finalDate')
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    children: [
                                      const Row(
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
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 22, 125, 209),
                                                    deleteIconColor:
                                                        Colors.yellow,
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Personal skills',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
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
                                                        deleteIconColor:
                                                            Colors.red,
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
                                                    backgroundColor:
                                                        Color.fromARGB(
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
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    )
                  : Center(child: Text('Invalid user ID')),
            ],
          ),
        ),
      ),
    );
  }
}
