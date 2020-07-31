import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/entities/category.entities.dart';
import 'package:venda_mais_client_buy/repositories/category.repository.dart';
import 'package:venda_mais_client_buy/repositories/category.repository.interface.dart';

class CategoryController {
  ICategoryRepository repository;
  ConnectComponent connect;

  CategoryController(){
    repository = new CategoryRepository();
    connect = new ConnectComponent();
  }

  CategoryController.tests(this.repository, this.connect);

  Future<List<CategoryData>> getAll(String idSegment) async{
    if(await connect.checkConnect()) {
      return await repository.getAll(idSegment);
    } else {
      return [];
    }
  }
}