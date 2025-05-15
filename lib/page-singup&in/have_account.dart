import 'package:flutter/material.dart';

class HaveAccount extends StatelessWidget {
  final Function? press;
  const HaveAccount({super.key, required this.press});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Don’t have an Account ? ",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: const Text(
            "sign up",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
