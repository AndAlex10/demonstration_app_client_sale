import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:venda_mais_client_buy/repositories/signInFacebookAccount.repository.interface.dart';

class SignInFacebookAccountRepository implements ISignInFacebookAccountRepository{

  @override
  Future<UserEntity> signIn() async {
    UserEntity userEntity;

    final facebookLogin = FacebookLogin();
    final result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);
    FacebookAccessToken myToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: myToken.token);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=${result.accessToken.token}');

        Map data = json.decode(graphResponse.body);
        FirebaseUser user =
            await FirebaseAuth.instance.signInWithCredential(credential);

        DocumentSnapshot docUser = await Firestore.instance
            .collection("???")
            .document(user.uid)
            .get();
        if (docUser.data == null) {
          userEntity = new UserEntity();
          userEntity.id = docUser.documentID;
          userEntity.name = user.displayName;
          userEntity.email = user.email;
          userEntity.photo = data['picture']['data']['url'];
          await Firestore.instance
              .collection("???")
              .document(user.uid)
              .setData(userEntity.toMap());
        } else {
          userEntity = UserEntity.fromMap(docUser.data);
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        return null;
        break;
      case FacebookLoginStatus.error:
        return null;
        break;
    }

    return userEntity;
  }
}
