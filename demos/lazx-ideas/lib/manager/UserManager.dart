import 'package:lazx_idea/ui/auth/auth_repository.dart';

class UserManager {
  static UserManager? _instance;
  factory UserManager() => _instance ??= UserManager._();

  final AuthRepository _authRepository = AuthRepository();

  UserManager._();
}
