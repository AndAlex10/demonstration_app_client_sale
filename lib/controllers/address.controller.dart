import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class AddressController{
  IAddressRepository addressRepository;
  ConnectComponent connect;

  AddressController(){
    addressRepository = new AddressRepository();
    connect = new ConnectComponent();
  }

  AddressController.tests(this.addressRepository, this.connect);

  Future<ValidateResponse> alter(UserStore userStore, Address address) async{
    userStore.setLoading(true);
     ValidateResponse response = new ValidateResponse();
     if(await connect.checkConnect()) {
       addressRepository.alter(userStore.user, address);
       response.success = true;

     } else {
       response.failConnect();
     }
     userStore.setLoading(false);

     return response;
  }

  Future<ValidateResponse> remove(UserStore userStore, Address address) async{
    userStore.setLoading(true);
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      await addressRepository.remove(userStore.user, address);
      userStore.user.addressList = await addressRepository.load(userStore.user.id);
      response.success = true;

    } else {
      response.failConnect();
    }
    userStore.setLoading(false);

    return response;
  }

  Future<ValidateResponse> add(UserStore userStore, PlacesDetailsResponse detail, double lat, double long, number) async{
    userStore.setLoading(true);
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      Address address = Address.fromJson(
          detail, lat, long, userStore.user.addressList.length + 1);
      if (number != "") {
        address.number = number;
      }

      await addressRepository.add(userStore.user, address);
      userStore.user.addressList = await addressRepository.load(userStore.user.id);

      if (userStore.user.addressList.length == 1) {
        await addressRepository.setDefault(
            userStore.user, userStore.user.addressList[0]);
      }
      response.success = true;
    } else {
      response.failConnect();
    }
    userStore.setLoading(false);

    return response;
  }

  Future<ValidateResponse> setDefault(UserStore userStore, Address address) async{
    userStore.setLoading(true);
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      for (var i = 0; i < userStore.user.addressList.length; i++) {
        if (userStore.user.addressList[i].id != address.id) {
          if(userStore.user.addressList[i].defaultAddress) {
            userStore.user.addressList[i].defaultAddress = false;
            await addressRepository.setUnDefault(
                userStore.user.id, userStore.user.addressList[i]);
          }
        } else {
          userStore.user.addressList[i].defaultAddress = true;
        }
      }
      await addressRepository.setDefault(userStore.user, address);

      userStore.addressDefaultName = "${address.address}, ${address.number}, ${address.neighborhood}";
      response.success = true;
    } else {
      response.failConnect();
    }
    userStore.setLoading(false);
    return response;
  }

  bool validateAddress(EstablishmentData establishmentData, Address address){
    if(establishmentData.city == address.city && establishmentData.state == address.state){
      return true;
    } else {
      return false;
    }
  }

}