import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vetlink1/main.dart'; // تأكد من استيراد ملف main.dart الخاص بك

void main() {
  testWidgets('Login screen and theme toggle test', (
    WidgetTester tester,
  ) async {
    // بناء تطبيقنا وتحفيز الإطار.
    await tester.pumpWidget(const MyApp(isDarkMode: false, isLoggedIn: false));

    // تحقق من أن شاشة تسجيل الدخول تظهر
    expect(find.text('Login'), findsOneWidget);

    // محاكاة الضغط على زر تسجيل الدخول إذا كنت ترغب في اختبار التبديل لشاشة أخرى.
    // يمكنك استبدال `Login` بنص الزر أو شيء مشابه
    await tester.tap(find.byType(ElevatedButton)); // افتراضياً هذا النوع هو زر
    await tester.pumpAndSettle();

    // تحقق من التبديل إلى MainPage بعد تسجيل الدخول
    expect(
      find.text('Main Page'),
      findsOneWidget,
    ); // استبدل بنص أو عنصر موجود في MainPage

    // محاكاة التبديل بين الوضع الداكن والفاتح
    await tester.tap(
      find.byIcon(Icons.brightness_6),
    ); // مثال على أيقونة التبديل بين الأنماط
    await tester.pump();

    // تحقق من تغيير اللون أو نمط التطبيق
    expect(
      find.byWidgetPredicate(
        (widget) => widget is MaterialApp && widget.themeMode == ThemeMode.dark,
      ),
      findsOneWidget,
    );
  });
}
