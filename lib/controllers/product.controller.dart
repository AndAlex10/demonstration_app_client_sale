import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';
import 'package:venda_mais_client_buy/models/entities/options.entities.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';
import 'package:venda_mais_client_buy/repositories/product.repository.dart';
import 'package:venda_mais_client_buy/repositories/product.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/products.view.model.dart';

class ProductController {

  IProductRepository repository;
  ConnectComponent connect;

  ProductController(){
    repository = new ProductRepository();
    connect = new ConnectComponent();
  }

  ProductController.tests(this.repository, this.connect);

  Future<ProductsViewModel> getAll(String idEstablishment, MenuData menuData, String search) async {
    ProductsViewModel viewModel = new ProductsViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.list = await repository.getAll(idEstablishment, menuData, search);
    }

    return viewModel;
  }

  bool enableProduct(ProductData data) {
    bool result = true;
    if (data.options) {
      result = false;
      for (OptionsData option in data.optionsList) {
        if (option.check) {
          result = true;
        }
      }
    }

    return result;
  }

  double recalculateValue(ProductData data){
    double value = 0.0;
    if (data.options){
      for (var h = 0; h < data.optionsList.length; h++) {
        OptionsData optionsData = data.optionsList[h];
        if (optionsData.check) {
          value = optionsData.price;
        }
      }
    } else {
      for (var h = 0; h < data.additionalList.length; h++) {
        Additional additional = data.additionalList[h];
        if (additional.check) {
          value += additional.price;
        }
      }
      value = (data.price + value) ;
    }

    return value;
  }



}