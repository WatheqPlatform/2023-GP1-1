import 'package:flutter/material.dart';

class ConnectedCircles extends StatelessWidget {
  int pos = 0;
  ConnectedCircles({required this.pos});
  @override
  Widget build(BuildContext context) {
    final arr =[0,1,2,3,4];
    return Container(
      width: 300.0,
      height: 75.0,
      child: Stack(
        children: [
          ...[0,1,2,3].map((e) => Positioned(
            top: 30,
            left: 20 + e * 60,
            right: 60.0 * (4 - e),
            child: Container(
              width: 20,
              height: 2.0,
              color: e > pos -1 ? Colors.grey :Color(0xFF085399)
            ),
          )).toList(),
          ...arr.map((e) => Positioned(top: 10, left: e * 60, child: CircleWithText(number: (e + 1).toString(), color:  e > pos ? Colors.grey :Color(0xFF085399)))).toList()
        ],
      ),
    );
  }
}

class CircleWithText extends StatelessWidget {
  final String number;
  final Color color;
  CircleWithText({required this.number, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: color, // Change the color as needed
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 8.0), // Adjust the spacing between circle and text
      ],
    );
  }
}