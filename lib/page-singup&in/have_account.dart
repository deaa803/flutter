import 'package:flutter/material.dart';

class HaveAccount extends StatelessWidget {
  final VoidCallback? press;
  const HaveAccount({super.key, required this.press});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "ليس لديك حساب؟ ",
            style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
          ),
          GestureDetector(
            onTap: press,
            child: const Text(
              "إنشاء حساب",
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
