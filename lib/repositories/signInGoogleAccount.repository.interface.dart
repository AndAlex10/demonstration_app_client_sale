import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';

abstract class ISignInGoogleAccountRepository {

  Future<UserEntity> signIn();

  Future<Null> signOutGoogle();

  Future<FirebaseUser> signInWithGoogle(FirebaseAuth auth, GoogleSignIn googleSignIn);
}