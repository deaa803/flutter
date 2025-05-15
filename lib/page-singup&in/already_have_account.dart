import 'package:flutter/material.dart';

class AlreadyHaveAccount extends StatelessWidget {
  final Function? press;
  const AlreadyHaveAccount({super.key, required this.press});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "already have an account ? ",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: const Text(
            "log in",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
