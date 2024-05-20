import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignOutUseCase {
  final GoogleSignIn _googleSignIn;

  GoogleSignOutUseCase(this._googleSignIn);

  Future<void> signOut() async => await _googleSignIn.signOut();
}
