import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class GetCredentialFacebookUseCase {
  final FacebookAuth _facebookAuth;

  GetCredentialFacebookUseCase(this._facebookAuth);

  Future<OAuthCredential> call() async {
    final LoginResult loginResult = await _facebookAuth.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return facebookAuthCredential;
  }
}
