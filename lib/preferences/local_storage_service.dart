import '../models/user.dart';

abstract class LocalStorageService {
  Future<String?> getId();
  Future<void> save(User user);
  Future<void> delete();
}