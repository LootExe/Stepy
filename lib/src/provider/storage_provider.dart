abstract class StorageProvider<T> {
  Future<T?> read(String key);
  Future<bool> write(String key, T data);
  Future<bool> delete(String key);
  Future<bool> clear();
}
