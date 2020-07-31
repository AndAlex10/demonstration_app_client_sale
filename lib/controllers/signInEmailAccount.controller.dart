import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/signInEmailAccount.repository.dart';
import 'package:venda_mais_client_buy/repositories/signInEmailAccount.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class SignInEmailAccountController {
  ISignInEmailAccountRepository repository;
  IUserRepository userRepository;
  IAddressRepository addressRepository;
  ConnectComponent connect;

  SignInEmailAccountController(){
    repository = new SignInEmailAccountRepository();
    userRepository = new UserRepository();
    addressRepository = new AddressRepository();
    connect = new ConnectComponent();
  }

  SignInEmailAccountController.tests(this.repository, this.userRepository, this.addressRepository, this.connect);

  Future<ValidateResponse> signIn(UserStore userStore, String email, String pass) async {
    ValidateResponse response = new ValidateResponse();
    userStore.setLoading(true);
    if(await connect.checkConnect()) {
      userStore.setUser(await repository.signIn(email: email, pass: pass));
      if (userStore.user != null) {
        userStore.user.addressList =
        await addressRepository.load(userStore.user.id);
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

  Future<ValidateResponse> signUp(UserStore userStore, String name, String email, String pass, String phone) async {
    ValidateResponse response = new ValidateResponse();
    userStore.setLoading(true);
    if(await connect.checkConnect()) {
      userStore.setUser(await repository.signUpEmail(
          name: name, email: email, pass: pass, phone: phone));

      if (userStore.user != null) {
        response.success = true;
      } else {
        response.message = ErroMessages.FAIL_CREATE_ACCOUNT;
      }
    } else {
      response.failConnect();
    }
    userStore.setLoading(false);
    return response;
  }


  Future<ValidateResponse> signOut(UserStore appStore) async {
    ValidateResponse response = new ValidateResponse();
    appStore.setUser(null);
    if(await connect.checkConnect()) {
      repository.signOut();
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

  Future<void> recoverPass(String email) async{
    await repository.recoverPass(email);
  }
}