import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double? value;
  const CircularProgress({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.amber,
      ),
      height: 100,
      width: MediaQuery.of(context).size.width - 50,
      child: Row(
        children: [
          CircularProgressIndicator(
            strokeWidth: 6,
            value: this.value,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'COMPLETE YOUR PROFILE',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
