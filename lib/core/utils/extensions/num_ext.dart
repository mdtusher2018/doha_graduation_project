import 'package:flutter/material.dart';

extension NumExtension on num {
  // ─── SizedBox spacers ────────────────────────────────────
  SizedBox get verticalSpace => SizedBox(height: toDouble());
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  // ─── BorderRadius ────────────────────────────────────────
  BorderRadius get circular => BorderRadius.circular(toDouble());

  // ─── EdgeInsets ──────────────────────────────────────────
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
  EdgeInsets get paddingH =>
      EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get paddingV =>
      EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get paddingTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get paddingLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get paddingRight => EdgeInsets.only(right: toDouble());
}
