import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';

abstract class IMenuRepository{

  Future<List<MenuData>> getAll(String idEstablishment);

}