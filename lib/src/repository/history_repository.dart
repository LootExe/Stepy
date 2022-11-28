import '../model/step_data.dart';
import '../provider/database_provider.dart';

class HistoryRepository {
  HistoryRepository({required DatabaseProvider<StepData> database})
      : _database = database;

  final DatabaseProvider<StepData> _database;

  int get dailyAverage => _getDailyAverage();
  int get dailyRecord => _getDailyRecord();
  List<StepData> get dailyHistory =>
      _database.readAll().toList(growable: false);

  /// Initialize repository
  Future<void> initialize() async => await _database.initialize();

  /// Closes repository
  Future<void> close() async => await _database.close();

  /// Clear all entries in the repository
  Future<void> clear() async => await _database.clear();

  /// Add a new entry to the repository
  Future<bool> add(StepData entry) async => await _database.create(entry);

  int _getDailyAverage() {
    final entries = _database.readAll();

    if (entries.isEmpty) {
      return 0;
    }

    int average = 0;

    for (var data in entries) {
      average += data.steps;
    }

    return (average / entries.length).round();
  }

  int _getDailyRecord() {
    final entries = _database.readAll();

    if (entries.isEmpty) {
      return 0;
    }

    return entries
        .reduce((curr, next) => curr.steps > next.steps ? curr : next)
        .steps;
  }
}
