import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';
import 'package:venda_mais_client_buy/models/entities/options.entities.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';

abstract class IProductRepository {

  Future<List<ProductData>> getAll(String idEstablishment, MenuData menuData, String search);

  Future<List<Additional>> getAdditional(String idEstablishment,  MenuData menuData);

  Future<List<OptionsData>> getOptions(String idProduct, String idEstablishment,  MenuData menuData);
}