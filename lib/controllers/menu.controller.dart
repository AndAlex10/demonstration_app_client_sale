import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/repositories/menu.repository.dart';
import 'package:venda_mais_client_buy/repositories/menu.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/menu.view.model.dart';

class MenuController {
  IMenuRepository repository;
  ConnectComponent connect;

  MenuController(){
    repository = new MenuRepository();
    connect = new ConnectComponent();
  }

  MenuController.tests(this.repository, this.connect);

  Future<MenuViewModel> getAll(String idEstablishment) async{
    MenuViewModel viewModel = MenuViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.list = await repository.getAll(idEstablishment);
    }

    return viewModel;
  }
}