import 'package:flutter/material.dart';

import 'colors.dart';
import 'strings.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  Color get primaryColor => theme.primaryColor;

  Color get cardColor => theme.cardColor;

  ColorScheme get colorScheme => theme.colorScheme;

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  NavigatorState get navigator => Navigator.of(this);

  void goTo(Widget destination, [showAd = true]) {
    Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  FocusScopeNode get focusScope => FocusScope.of(this);

  ScaffoldState get scaffold => Scaffold.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
}

extension DateTimeExtention on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && day == other.day && month == other.month;
  }
  bool get isYesterday => isSameDay(DateTime.now().subtract(const Duration(days: 1)));
  bool get isToday => isSameDay(DateTime.now());
  bool get isTomorrow => isSameDay(DateTime.now().add(const Duration(days: 1)));
}

extension StringExtension on String {
  TipStatus get toTipStatus {
    switch (this) {
      case Strings.pending:
        return TipStatus.pending;
      case Strings.won:
        return TipStatus.won;
      case Strings.lost:
        return TipStatus.lost;
      case Strings.canceled:
        return TipStatus.canceled;
      default:
        return TipStatus.pending;
    }
  }
}

enum TipStatus {
  pending(Strings.pending, AppColors.orangeColor),
  won(Strings.won, AppColors.greenColor),
  lost(Strings.lost, AppColors.redColor),
  canceled(Strings.canceled, AppColors.blueColor);

  final String status;
  final Color color;

  const TipStatus(this.status, this.color);
}


