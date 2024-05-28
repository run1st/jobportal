import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/Employers/home_page/candidateProfile.dart';

class CandidatesList extends StatefulWidget {
  final String jobId;

  CandidatesList({Key? key, required this.jobId}) : super(key: key);

  @override
  State<CandidatesList> createState() => _CandidatesListState();
}

class _CandidatesListState extends State<CandidatesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicants'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('employers-job-postings')
            .doc('post-id')
            .collection('job posting')
            .doc(widget.jobId)
            .collection('candidates')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('OOPS there is no posted jobs'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 7,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                            ),
                            child: Center(
                              child: Text('${snapshot.data!.docs.length}'),
                            ),
                          ),
                          const Text('Candidates'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 600,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          String institution = data['education']
                                  ?['institution'] ??
                              'institution';
                          String fieldOfStudy =
                              data['education']?['fieldOfStudy'] ?? '';

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              style: ListTileStyle.drawer,
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(institution),
                              subtitle: Container(
                                width: 20,
                                child: Text(fieldOfStudy),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    candidateProfile.routeName,
                                    arguments: [
                                      data['personal-info']?['id'] ?? '',
                                      widget.jobId
                                    ],
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  width: 100,
                                  height: 40,
                                  child: const Center(
                                    child: Text(
                                      'Review Profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
