
import 'package:venda_mais_client_buy/constants/erros.messages.dart';

class ValidateResponse {
  bool success = false;
  String message;

  failConnect(){
    success = false;
    message = ErroMessages.CONNECT_INTERNET;
  }

}