import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String placeholder; // Add this line to receive the initial text value

  Input(
      {required this.placeholder}); // Constructor to receive the initial text value

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Container(
        height: 50,
        width: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: TextFormField(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Color(0xFFAAAAAA),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }
}
