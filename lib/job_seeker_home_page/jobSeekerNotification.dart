import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/job_seeker_home_page/image_card.dart';
import 'package:intl/intl.dart'; // Import the intl package

class JobSeekerNotification extends StatefulWidget {
  static const routeName = 'JobSeekerNotification';

  @override
  _JobSeekerNotificationState createState() => _JobSeekerNotificationState();
}

class _JobSeekerNotificationState extends State<JobSeekerNotification> {
  String currentUser = '';

  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
        });
      } else {
        print('No user is signed in.');
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

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${DateFormat.yMMMd().format(dateTime)} at ${DateFormat.jm().format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser.isEmpty) {
      // User not logged in, show a placeholder widget
      return const Center(
        child: Text('Please log in to view notifications.'),
      );
    }
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job-seeker')
            .doc(currentUser)
            .collection('messages')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // No data or empty messages list
            return const Center(
              child: ImageCard(
                imagePath: 'assets/images/noNotification.jpg',
                imageCaption: 'No messages found',
              ),
            );
          }

          List<DocumentSnapshot> postedJobs = snapshot.data!.docs.toList();

          return SafeArea(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: postedJobs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = postedJobs[index];
                Timestamp timestamp = document['timestamp'] as Timestamp;
                String formattedDate = formatTimestamp(timestamp);

                return GestureDetector(
                  onTap: () {
                    // Handle onTap action
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          offset: Offset(0.0, 4.0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          document['senderInfo'] != null
                              ? document['senderInfo']['name']
                              : 'Company',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              document['content'],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Date: $formattedDate',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
