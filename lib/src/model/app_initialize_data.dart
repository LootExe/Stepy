class AppInitializeData {
  const AppInitializeData({
    required this.isForegroundRunning,
    required this.isPedometerPermissionGranted,
  });

  final bool isForegroundRunning;
  final bool isPedometerPermissionGranted;
}
