import '../model/log_data.dart';
import '../provider/database_provider.dart';

class LoggerRepository {
  LoggerRepository({
    required DatabaseProvider<LogData> database,
  }) : _database = database;

  final DatabaseProvider<LogData> _database;

  List<LogData> get entries => _database.readAll().toList(growable: false);

  /// Initialize repository
  Future<void> initialize() async => await _database.initialize();

  /// Closes repository
  Future<void> close() async => await _database.close();

  /// Clear all entries in the repository
  Future<void> clear() async => await _database.clear();

  /// Add a new entry to the repository
  Future<bool> add(LogData entry) async => await _database.create(entry);
}
