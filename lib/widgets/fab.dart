import 'package:flutter/material.dart';

class Fab extends StatelessWidget {
  final Function()? onPressed;
  const Fab({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      
      onPressed: onPressed,
      child: Icon(Icons.add),
      
    );
  }
}
