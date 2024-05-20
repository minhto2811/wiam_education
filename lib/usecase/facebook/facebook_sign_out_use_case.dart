import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignOutUseCase {
  final FacebookAuth _facebookAuth;

  FacebookSignOutUseCase(this._facebookAuth);

  Future<void> signOut() async => await _facebookAuth.logOut();
}
