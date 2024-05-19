import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/Employers/home_page/appliers.dart';

import '../models/jobs_model.dart';

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
    print('the document pathe is ${currentUser}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('employer')
            .doc(currentUser)
            .collection('job posting')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData || snapshot.data == null) {
            return const Text('OOPS there is no posted jobs');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: Text('Loading...'));

            default:
              return SafeArea(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 247, 244, 244),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: SizedBox(
                              height: 120,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  // side: BorderSide(color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                style: ListTileStyle.drawer,
                                leading: CircleAvatar(
                                  foregroundImage: NetworkImage(document[
                                          'company']['logoUrl'] ??
                                      'https://www.bing.com/images/search?view=detailV2&ccid=q182Q4Zy&id=D8C88B9D55DB76A095EADD6BDE4D4DF28EFD9B65&thid=OIP.q182Q4ZyCS-WUHuYGfac4QHaDt&mediaurl=https%3a%2f%2fhitechengineeringindia.com%2fimg%2fheader-img%2fprofile.jpg&cdnurl=https%3a%2f%2fth.bing.com%2fth%2fid%2fR.ab5f36438672092f96507b9819f69ce1%3frik%3dZZv9jvJNTd5r3Q%26pid%3dImgRaw%26r%3d0&exph=834&expw=1666&q=image+for+company+profile+picture&simid=608015538228691274&FORM=IRPRST&ck=97AE052C55DA4BCF742295A439E9F6CE&selectedIndex=22'),

                                  // :child: Icon(Icons.person),
                                ),
                                //  leading: new Text(document['job category']),
                                title: Text(
                                  document['title'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  children: [
                                    Text(document['job category']),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(document['employment type']),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Appliers(
                                              jobId: document['job id'],
                                            )),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Text(
                                      'View Appliers',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    width: 100,
                                    height: 40,
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
