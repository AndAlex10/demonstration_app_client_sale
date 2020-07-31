import 'package:venda_mais_client_buy/models/entities/user.entities.dart';

abstract class IUserRepository {

  Future<Null> create(UserEntity userEntity);

  Future<bool> save(UserEntity userEntity);

  Future<UserEntity> load();

}
