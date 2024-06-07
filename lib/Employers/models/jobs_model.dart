import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  String companyId;
  String name;
  String address;
  String city;
  String state;
  String country;
  String phone;
  String email;
  String website;
  String description;
  String industry;
  String companySize;
  String logoUrl;

  Company({
    required this.companyId,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.phone,
    required this.email,
    required this.website,
    required this.description,
    required this.industry,
    required this.companySize,
    required this.logoUrl,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['companyId'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      description: json['description'],
      industry: json['industry'],
      companySize: json['company-size'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'phone': phone,
      'email': email,
      'website': website,
      'industry': industry,
      'company-size': companySize,
      'logoUrl': logoUrl,
      'companyId': companyId,
    };
  }
}

//Job Post Model
class JobPost {
  DateTime timePosted;
  String JobId;
  String title;
  String category;
  String description;
  List requirements;

  String? salary;
  String employmentType;
  String location;
  String experienceLevel;
  String educationLevel;
  DateTime deadline;
  Map<String, dynamic>? company;
  //bool isFavorite;

  JobPost({
    required this.timePosted,
    required this.JobId,
    required this.title,
    required this.category,
    required this.description,
    required this.requirements,
    required this.salary,
    required this.employmentType,
    required this.location,
    required this.experienceLevel,
    required this.educationLevel,
    required this.deadline,
    required this.company,
    //  required this.isFavorite,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      timePosted: DateTime.parse(json['posted time']),
      JobId: json['job id'],
      title: json['title'],
      description: json['description'],
      requirements: json['requirements'],
      location: json['location'],
      salary: json['salary'],
      deadline: DateTime.parse(json['deadline']),
      company: json['company'],
      employmentType: json['employment type'],
      experienceLevel: json['experience level'],
      educationLevel: json['education level'],
      category: json['job category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posted time': timePosted,
      'job id': JobId,
      'title': title,
      'description': description,
      'requirements': requirements,
      'location': location,
      'salary': salary,
      'deadline': deadline,
      'company': company,
      'employment type': employmentType,
      'experience level': experienceLevel,
      'education level': educationLevel,
      'job category': category,
    };
  }

  // void toggleFavoriteStatus() {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  // }
}

// class model for messages
class Message {
  String id;
  String senderId;
  String recipientId;
  String content;
  DateTime timestamp;
  bool isRead;
  var company;

  Message(
      {required this.id,
      required this.senderId,
      required this.recipientId,
      required this.content,
      required this.timestamp,
      required this.isRead,
      required this.company});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'],
      company: Company.fromJson(json['senderInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'timestamp': timestamp,
      //.toIso8601String(),
      'isRead': isRead,
      'senderInfo': company
    };
  }
}
