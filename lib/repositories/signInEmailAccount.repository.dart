import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:venda_mais_client_buy/enums/login.type.enum.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/repositories/signInEmailAccount.repository.interface.dart';

class SignInEmailAccountRepository implements ISignInEmailAccountRepository {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser fbUser;

  @override
  Future<UserEntity> signIn(
      {@required String email, @required String pass}) async {
    UserEntity userEntity;
    await auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      fbUser = user;
      if (fbUser != null) {
        DocumentSnapshot doc = await Firestore.instance
            .collection("???")
            .document(fbUser.uid)
            .get();

        if (doc.data != null) {
          userEntity = UserEntity.fromMap(doc.data);
          userEntity.loginType = LoginType.EMAIL.index;

          await Firestore.instance
              .collection("???")
              .document(fbUser.uid)
              .updateData({"???": LoginType.EMAIL.index});
        } else {
          userEntity = null;
        }

      }
    }).catchError((e) {
      userEntity = null;
    });

    return userEntity;
  }

  void signOut() async {
    await auth.signOut();
  }

  @override
  Future<UserEntity> signUpEmail(
      {@required String name,
      @required String email,
      @required String pass,
      @required String phone}) async {
    UserEntity userEntity = new UserEntity();

    auth.createUserWithEmailAndPassword(email: email, password: pass)
        .then((data) async {
      fbUser = data;
      userEntity.id = fbUser.uid;
      userEntity.email = fbUser.email;
      userEntity.photo = fbUser.photoUrl;
      userEntity.name = name;
      userEntity.phone = phone;
      userEntity.loginType = LoginType.EMAIL.index;
      await Firestore.instance.collection("???").document(fbUser.uid).setData(userEntity.toMap());

    }).catchError((e) {
      userEntity = null;
    });
    return userEntity;
  }

  @override
  Future<void> recoverPass(String email) async{
    await auth.sendPasswordResetEmail(email: email);
  }
}
