import 'package:venda_mais_client_buy/models/entities/user.entities.dart';

abstract class ISignInFacebookAccountRepository {
  Future<UserEntity> signIn();
}
