import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/establishments.view.model.dart';

class EstablishmentController {
  IEstablishmentRepository repository;
  ConnectComponent connect;

  EstablishmentController(){
    repository = new EstablishmentRepository();
    connect = new ConnectComponent();
  }

  EstablishmentController.tests(this.repository, this.connect);

  Future<EstablishmentsViewModel> getWithFilterName(String idSegment, String text, UserEntity userEntity) async {
    EstablishmentsViewModel viewModel = new EstablishmentsViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      String city = '';
      String state = '';

      for (var i = 0; i < userEntity.addressList.length; i++) {
        if (userEntity.addressList[i].defaultAddress) {
          city = userEntity.addressList[i].city;
          state = userEntity.addressList[i].state;
        }
      }
      viewModel.list = await repository.getWithFilterName(idSegment, text, city, state);
    }
    return viewModel;
  }

  Future<EstablishmentsViewModel> getAll(String idSegment, String idCategory, UserEntity userEntity) async {
    EstablishmentsViewModel viewModel = new EstablishmentsViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      String city = '';
      String state = '';

      for (var i = 0; i < userEntity.addressList.length; i++) {
        if (userEntity.addressList[i].defaultAddress) {
          city = userEntity.addressList[i].city;
          state = userEntity.addressList[i].state;
        }
      }
      viewModel.list = await repository.getAll(idSegment, idCategory, city, state);
    }

    return viewModel;
  }
}