import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:venda_mais_client_buy/enums/login.type.enum.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/repositories/signInGoogleAccount.repository.interface.dart';

class SignInGoogleAccountRepository implements ISignInGoogleAccountRepository {
  GoogleSignIn googleSignIn;

  SignInGoogleAccountRepository(){
    googleSignIn = GoogleSignIn();
  }

  @override
  Future<UserEntity> signIn() async{
    UserEntity userEntity;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser;

    await signInWithGoogle(auth, googleSignIn).then((data) async {
      firebaseUser = data;

      if (firebaseUser != null) {

        DocumentSnapshot doc = await Firestore.instance
            .collection("???")
            .document(firebaseUser.uid).get();

        if(doc.data != null) {
          userEntity = UserEntity.fromMap(doc.data);
        } else {
          userEntity = new UserEntity();
        }
        userEntity.id = firebaseUser.uid;
        userEntity.email = firebaseUser.email;
        userEntity.photo = firebaseUser.photoUrl;
        userEntity.name = firebaseUser.displayName;
        userEntity.loginType = LoginType.GOOGLE.index;

        await Firestore.instance
            .collection("???")
            .document(firebaseUser.uid)
            .setData(userEntity.toMap());
      }

    }).catchError((e) {
      userEntity = null;
    });

    return userEntity;
  }

  @override
  Future<FirebaseUser> signInWithGoogle(FirebaseAuth auth, GoogleSignIn googleSignIn) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user = await auth.signInWithCredential(credential);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  @override
  Future<Null> signOutGoogle() async {
    await googleSignIn.signOut();
  }


}