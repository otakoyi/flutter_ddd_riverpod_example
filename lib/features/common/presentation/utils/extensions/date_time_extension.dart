import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Extension that allows to substitute [DateTime.now] with a testable function
extension DateTimeX on DateTime {
  /// Allows copying [DateTime] with an arbitrary shift in time
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// Default [DateTime] format to be used on the UI
  String defaultString() {
    return DateFormat.yMMMd().format(this);
  }

  static DateTime? _customTime;

  /// Method that allows to get current [DateTime] in runtime or custom [DateTime] in tests
  static DateTime get current {
    return _customTime ?? DateTime.now();
  }

  @visibleForTesting
  static set customTime(DateTime? customTime) {
    _customTime = customTime;
  }
}
