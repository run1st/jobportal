import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/Employers/home_page/candidatesList.dart';

class candidates extends StatefulWidget {
  static const routeName = 'candidates';

  @override
  _candidatesState createState() => _candidatesState();
}

class _candidatesState extends State<candidates> {
  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('employer')
            .doc(getCurrentUserUid())
            .collection('job posting')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData)
            return Center(child: Text('OOPS there is no posted jobs'));

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

            default:
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.work, color: Colors.white),
                            ),
                            title: Text(
                              data['title'] ?? 'Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  data['job category'] ?? 'Category',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  data['employment type'] ?? 'Employment Type',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            trailing: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CandidatesList(
                                    jobId: data['job id'] ?? '',
                                  ),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: 100,
                                height: 40,
                                child: const Center(
                                  child: Text(
                                    'Candidates',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
