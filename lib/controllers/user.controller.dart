import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/controllers/signInEmailAccount.controller.dart';
import 'package:venda_mais_client_buy/controllers/signInGoogleAccount.controller.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/enums/login.type.enum.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/payment.card.repository.dart';
import 'package:venda_mais_client_buy/repositories/payment.card.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class UserController {

  IUserRepository userRepository;
  IAddressRepository addressRepository;
  IPaymentCardRepository paymentCardRepository;
  ConnectComponent connect;

  UserController(){
     userRepository = new UserRepository();
     addressRepository = new AddressRepository();
     paymentCardRepository = new PaymentCardRepository();
     connect = new ConnectComponent();
  }

  UserController.tests(this.userRepository, this.addressRepository, this.paymentCardRepository, this.connect);
  
  Future<ValidateResponse> save(UserStore userStore) async {
    ValidateResponse response = new ValidateResponse();
    userStore.setLoading(true);
    if(await connect.checkConnect()) {
      response.success = await userRepository.save(userStore.user);
      if(!response.success){
        response.message = ErroMessages.FAIL_UPDATE_USER;
      }
    } else {
      response.failConnect();
    }
    userStore.setLoading(false);
     return response;
  }

  Future<UserEntity> load() async {
    UserEntity userEntity;
    if(await connect.checkConnect()) {
      userEntity = await userRepository.load();
      if (userEntity != null) {
        userEntity.addressList = await addressRepository.load(userEntity.id);
        userEntity.paymentList =
        await paymentCardRepository.load(userEntity.id);
      }
    }
    return userEntity;
  }

  void signOutAccount(UserStore userStore){
    if (userStore.user.loginType == LoginType.GOOGLE.index){
      SignInGoogleAccountController account = new SignInGoogleAccountController();
      account.signOutGoogle(userStore);

    } else if (userStore.user.loginType == LoginType.EMAIL.index){
      SignInEmailAccountController account = new SignInEmailAccountController();
      account.signOut(userStore);
    }

  }

  String getTitleAddressDefault(List<Address> addressList) {
    String title = '';

    for (Address address in addressList) {
      if (address.defaultAddress) {
        title = "${address.address}, ${address.number}, ${address.neighborhood}";
      }
    }

    if (title == '') {
      title = 'Não tem endereço definido!';
    }
    return title;
  }
}