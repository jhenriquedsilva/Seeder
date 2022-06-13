import '../database/user_dao.dart';
import '../models/user.dart';
import '../network/user_http_service.dart';

class UserRepository {
  UserRepository(
    this._authService,
    this._userDao,
  );

  final UserHttpService _authService;
  final UserDao _userDao;

  Future<void> login(String email) async {
    final user = await _authService.login(email);
    await _userDao.insert(user);
  }

  Future<void> signup(String fullName, String email) async {
    final user = await _authService.signup(fullName, email);
    await _userDao.insert(user);
  }

  Future<List<User>> getUser() async {
    final userList = await _userDao.getUsers();
    return userList;
  }

  Future<void> delete() async {
    await _userDao.clear();
  }
}
