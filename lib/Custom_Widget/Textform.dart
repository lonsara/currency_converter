import 'package:flutter/material.dart';

class Textform extends StatefulWidget {
  TextEditingController amount=TextEditingController();
  final String? hinttxt;
  Textform({super.key,required this.amount,required this.hinttxt});

  @override
  State<Textform> createState() => _TextformState();
}

class _TextformState extends State<Textform> {
  final _formkey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
        child: TextFormField(
          validator: (String? value) {
            if (value == null || value.isNotEmpty) {
              return 'Please enter a valid amount';
            }
            return null;
          },
          controller: widget.amount,
          decoration: InputDecoration(
            hintText: widget.hinttxt,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.orange,
                width: 1,
              ),
            ),
          ),
        )
    );
  }
}
