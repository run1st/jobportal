import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/Employers/home_page/appliers.dart';

class Posted_jobs extends StatefulWidget {
  static const routeName = 'Posted_jobs';
  @override
  _Posted_jobsState createState() => _Posted_jobsState();
}

class _Posted_jobsState extends State<Posted_jobs> {
  Stream<QuerySnapshot>? jobPostingsStream;
  String? currentUser;

  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
          jobPostingsStream = FirebaseFirestore.instance
              .collection('employer')
              .doc(currentUser)
              .collection('job posting')
              .snapshots();
        });
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
    print('the document path is ${currentUser}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: jobPostingsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('OOPS there are no posted jobs'));
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            default:
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Card(
                          color: const Color.fromARGB(255, 247, 244, 244),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: data['company']?['logoUrl'] !=
                                        null
                                    ? NetworkImage(data['company']?['logoUrl'])
                                    : const NetworkImage(
                                        'https://via.placeholder.com/150/000000/FFFFFF/?text=Company'),
                                onBackgroundImageError: (_, __) =>
                                    const Icon(Icons.error, color: Colors.red),
                              ),
                              title: Text(
                                data['title'] ?? 'Title',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['job category'] ?? 'Category',
                                        style:
                                            TextStyle(color: Colors.grey[700])),
                                    const SizedBox(height: 5),
                                    Text(
                                        data['employment type'] ??
                                            'Employment Type',
                                        style:
                                            TextStyle(color: Colors.grey[700])),
                                  ],
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Appliers(
                                      jobId: data['job id'],
                                    ),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: const Text(
                                    'View Appliers',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
