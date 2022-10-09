import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final String hintText;
  final VoidCallback onsave;
  final VoidCallback oncancel;

  const MyAlertBox({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onsave,
    required this.oncancel,
  }) : super(key: key);

  Widget btn(String title, BuildContext context, Function()? onpressed) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      onPressed: onpressed,
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: TextField(
        
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(10),
          label: Text('Habit'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      actions: [
        btn('Cancel', context, oncancel),
        btn('Save', context, onsave),
      ],
    );
  }
}
