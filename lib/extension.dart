import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ContextExt on BuildContext {
  T read<T>() => Provider.of<T>(this);

  T watch<T>() => Provider.of<T>(this, listen: true);

  Color get primaryColor => Theme.of(this).primaryColor;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  void showCustomSnackBar(String message) {
    if (!mounted) return;
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void displayDialog(Widget dialog) {
    if (!mounted) return;
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void displayAlertDialog({
    required String title,
    required String content,
    VoidCallback? onPositivePressed,
    String positiveButtonText = 'OK',
    VoidCallback? onNegativePressed,
    String negativeButtonText = 'Cancel',
  }) {
    if (!mounted) return;
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: content != null ? Text(content) : null,
          actions: <Widget>[
            TextButton(
              onPressed: onNegativePressed ??
                  () {
                    Navigator.of(this).pop();
                  },
              child: Text(negativeButtonText),
            ),
            TextButton(
              onPressed: onPositivePressed ??
                  () {
                    Navigator.of(this).pop();
                  },
              child: Text(positiveButtonText),
            ),
          ],
        );
      },
    );
  }
}

extension DateTimeExt on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  bool isYesterday() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return day == yesterday.day &&
        month == yesterday.month &&
        year == yesterday.year;
  }
}

extension StringExt on String {
  bool isValidPassword() {
    return RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$').hasMatch(this);
  }

  bool isValidEmail() {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(this);
  }

  // Format: yyyy-MM-dd HH:mm:ss
  DateTime toDateTime() {
    return DateTime.parse(this);
  }
}

extension NumExt on num {
  SizedBox get heightBox => SizedBox(
        height: toDouble(),
      );

  SizedBox get widthBox => SizedBox(
        width: toDouble(),
      );

  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get leftPadding => EdgeInsets.only(left: toDouble());

  EdgeInsets get rightPadding => EdgeInsets.only(right: toDouble());

  EdgeInsets get topPadding => EdgeInsets.only(top: toDouble());

  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: toDouble());
}

extension WidgetExt on Widget {
  Opacity setOpacity(double val) => Opacity(
        opacity: val,
        child: this,
      );
}
