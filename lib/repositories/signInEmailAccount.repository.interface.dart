import 'package:flutter/cupertino.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';

abstract class ISignInEmailAccountRepository {

  Future<UserEntity> signIn({@required String email,
    @required String pass});

  void signOut();

  Future<UserEntity> signUpEmail({@required String name, @required String email,
    @required String pass, @required String phone});

  Future<void> recoverPass(String email);

}