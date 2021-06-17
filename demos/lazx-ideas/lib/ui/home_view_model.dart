import 'package:lazx/lazx.dart';

import 'auth/auth_manager.dart';

class HomeViewModel extends LazxViewModel {
  LazxState logoutRequest = LazxState();
  @override
  List<LazxObservable> get props => [logoutRequest];

  @override
  void init() {
    AuthManager().authenticated.observer.listen((authenticated) {
      if (!authenticated) {
        logoutRequest.setState(LxState.Success);
      }
    });
  }

  Future<void> logout() async {
    final response = await AuthManager().logout();
    if (!response.success) {
      logoutRequest.setState(LxState.Error);
    }
  }
}
