class UserManager {
  static UserManager? _instance;
  factory UserManager() => _instance ??= UserManager._();

  UserManager._();
}
