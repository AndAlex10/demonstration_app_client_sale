import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';

abstract class IAddressRepository {

  Future<List<Address>> load(String idUser);

  Future<Null> alter(UserEntity userEntity, Address address);

  Future<Null> remove(UserEntity userEntity, Address address);

  Future<Null> add(UserEntity userEntity, Address address);

  Future<Null> setDefault(UserEntity userEntity, Address address);

  Future<Null> setUnDefault(String id, Address address);
}