import 'package:flutter/material.dart';

class AlreadyHaveAccount extends StatelessWidget {
  final VoidCallback? press;
  const AlreadyHaveAccount({super.key, required this.press});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "لديك حساب بالفعل؟ ",
            style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
          ),
          GestureDetector(
            onTap: press,
            child: const Text(
              "تسجيل الدخول",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
