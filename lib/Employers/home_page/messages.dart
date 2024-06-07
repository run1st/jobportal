import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/Employers/models/jobs_model.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class ComposeMessageScreen extends StatefulWidget {
  final String? jobApplierId;

  ComposeMessageScreen({
    Key? key,
    required this.jobApplierId,
  }) : super(key: key);

  @override
  _ComposeMessageScreenState createState() => _ComposeMessageScreenState();
}

class _ComposeMessageScreenState extends State<ComposeMessageScreen> {
  List<Message> _sentMessages = [];

  String _statusMessage = '';

  TextEditingController _messageController = TextEditingController();
  String currentUser = '';

  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
        });
        await fetchAndSaveCompanyData();
      } else {
        print('No user is signed in.');
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  bool sendMessageToJobSeeker(String message) {
    return message.isNotEmpty; // Simulating success if the message is not empty
  }

  String createMessageId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  Future saveMessage(String id, Message message) async {
    final jsonData = message.toJson();
    final messageDocumentReference = FirebaseFirestore.instance
        .collection('job-seeker')
        .doc(id)
        .collection('messages')
        .doc(createMessageId());
    await messageDocumentReference.set(jsonData);
  }

  Company? companyProfile;
  Future<void> fetchAndSaveCompanyData() async {
    try {
      print('Fetching company data for user: $currentUser');
      if (currentUser == null) {
        throw Exception('Error: currentUser is null');
      }

      final empDocRef =
          FirebaseFirestore.instance.collection('employer').doc(currentUser);
      final empProfileRef =
          empDocRef.collection('company profile').doc('profile');

      final docSnapshot = await empProfileRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          setState(() {
            companyProfile = Company.fromJson(data);
          });
          print(
              'Company data fetched and saved to global variable: ${companyProfile!.toJson()}');
        } else {
          print('Error: No data found in the document.');
        }
      } else {
        print('Error: Document does not exist.');
      }
    } on FirebaseException catch (e) {
      print('Error fetching company data: ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${DateFormat.yMMMd().format(dateTime)} at ${DateFormat.jm().format(dateTime)}';
  }

  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.jobApplierId == null || widget.jobApplierId!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Compose Message'),
        ),
        body: const Center(
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                'Invalid job applier ID.',
                style: TextStyle(fontSize: 16.0, color: Colors.red),
              ),
              Text(
                'Or Applier is not available.',
                style: TextStyle(fontSize: 16.0, color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Message'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job-seeker')
            .doc(widget.jobApplierId)
            .collection('messages')
            .where('senderId', isEqualTo: currentUser)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<DocumentSnapshot> sentMessages = [];
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            sentMessages = querySnapshot.docs.toList();
          }
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) {
            return const Text('OOPS there are no messages yet');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      String messageId = createMessageId();
                      String message = _messageController.text;

                      if (message.isEmpty) {
                        setState(() {
                          _statusMessage = 'Message cannot be empty';
                        });
                        return;
                      }

                      final messageObject = Message(
                          id: messageId,
                          senderId: currentUser,
                          recipientId: widget.jobApplierId!,
                          content: message,
                          timestamp: DateTime.now(),
                          isRead: false,
                          company: companyProfile);
                      saveMessage(widget.jobApplierId!, messageObject);

                      setState(() {
                        _statusMessage = 'Message sent successfully';
                      });

                      _messageController.clear();
                    },
                    child: Text('Send'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  if (_statusMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          color: _statusMessage.contains('success')
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sentMessages.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot message = sentMessages[index];
                        String date = formatTimestamp(message['timestamp']);
                        return Card(
                          elevation: 0,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            tileColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            title: Text(
                              message['content'],
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                date,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
