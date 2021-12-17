import 'package:flutter/material.dart';

extension ContextExtention on BuildContext {
  double getDynmaicHeight(double val) => MediaQuery.of(this).size.height * val;
  double getDynmaicWidth(double val) => MediaQuery.of(this).size.width * val;
}
