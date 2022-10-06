extension CapExtension on String {
  String capitalize() {
    return (length > 1) ? this[0].toUpperCase() + substring(1) : toUpperCase();
  }
}
