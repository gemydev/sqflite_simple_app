import 'package:flutter/material.dart';

// Go and come back
Future<bool> normalShift(BuildContext context, Object page) async {
  bool result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => page));
  return result;
}

// Go and don't come back
shiftByReplacement(BuildContext context, Object page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void moveToLastScreen(BuildContext context) {
  Navigator.pop(context, true);
}
