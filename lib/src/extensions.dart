extension DateUtils on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool get isPastDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return isBefore(today);
  }
}

extension CapExtension on String {
  String capitalize() {
    return (length > 1) ? this[0].toUpperCase() + substring(1) : toUpperCase();
  }
}

extension NumExtension on num {
  num remap(num fromLow, num fromHigh, num toLow, num toHigh) {
    return (this - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;
  }
}
