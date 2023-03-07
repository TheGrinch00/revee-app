import 'package:flutter/material.dart';

extension BetterTimeOfDay on TimeOfDay {
  double toDouble() {
    return hour.toDouble() + minute.toDouble() / 60;
  }

  bool operator >(TimeOfDay other) {
    return toDouble() > other.toDouble();
  }
}
