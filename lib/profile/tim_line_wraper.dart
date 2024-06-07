import 'package:flutter/material.dart';
import 'package:project1/profile/time_line_tile.dart';

class MyTimeLineWrapper extends StatefulWidget {
  final bool personal;
  final bool education;
  final bool experience;
  final bool skills;
  const MyTimeLineWrapper(
      {super.key,
      required this.personal,
      required this.education,
      required this.experience,
      required this.skills});

  @override
  State<MyTimeLineWrapper> createState() => _MyTimeLineWrapperState();
}

class _MyTimeLineWrapperState extends State<MyTimeLineWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: SizedBox(
          height: 300,
          child: ListView(
            children: [
              MyTimeLine(
                isFirst: true,
                isLast: false,
                isPast: widget.personal,
                section: 'Personal',
              ),
              MyTimeLine(
                isFirst: false,
                isLast: false,
                isPast: widget.education,
                section: 'Education',
              ),
              MyTimeLine(
                isFirst: false,
                isLast: true,
                isPast: widget.experience,
                section: 'Experience',
              ),
              MyTimeLine(
                isFirst: false,
                isLast: true,
                isPast: widget.skills,
                section: 'Skills & other',
              )
            ],
          ),
        ),
      ),
    );
  }
}
