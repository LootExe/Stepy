import 'package:hive/hive.dart';

abstract class DatabaseProvider<T extends HiveObject> {
  Future<bool> initialize();
  Future<void> close();

  Future<bool> create(T entry);
  T? read(int id);
  Iterable<T> readAll();
  Future<void> clear();
}
