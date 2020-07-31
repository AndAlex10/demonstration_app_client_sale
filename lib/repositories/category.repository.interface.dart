import 'package:venda_mais_client_buy/models/entities/category.entities.dart';

abstract class ICategoryRepository {

  Future<List<CategoryData>> getAll(String idSegment);
}