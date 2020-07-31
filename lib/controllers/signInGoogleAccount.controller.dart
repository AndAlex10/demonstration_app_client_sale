import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/signInGoogleAccount.repository.dart';
import 'package:venda_mais_client_buy/repositories/signInGoogleAccount.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class SignInGoogleAccountController {
  ISignInGoogleAccountRepository repository;
  IUserRepository userRepository;
  IAddressRepository addressRepository;
  ConnectComponent connect;

  SignInGoogleAccountController(){
    repository = new SignInGoogleAccountRepository();
    userRepository = new UserRepository();
    addressRepository = new AddressRepository();
    connect = new ConnectComponent();
  }

  SignInGoogleAccountController.tests(this.repository, this.userRepository, this.addressRepository, this.connect);

  Future<ValidateResponse> signIn(UserStore userStore) async {
    ValidateResponse response = new ValidateResponse();
    userStore.setLoading(true);
    if(await connect.checkConnect()) {
      userStore.setUser(await repository.signIn());

      if (userStore.user != null) {
        userStore.user.addressList =
        await addressRepository.load( userStore.user.id);
        response.success = true;
      } else {
        response.message = ErroMessages.FAIL_LOGIN;
      }
    } else {
      response.failConnect();
    }

    userStore.setLoading(false);
    return response;
  }

  Future<ValidateResponse> signOutGoogle(UserStore userStore) async {
    ValidateResponse response = new ValidateResponse();

    if(await connect.checkConnect()) {
      userStore.setUser(null);
      repository.signOutGoogle();
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }
}