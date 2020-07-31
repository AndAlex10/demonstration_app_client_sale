

import 'package:venda_mais_client_buy/enums/cielo.card.status.enum.dart';

class CieloResponse {
  bool success = false;
  String message;

  CieloResponse(String status){
    success = CieloStatusReturn.verifyProcess(status);
    message = CieloStatusReturn.messageReturn(status);
  }
}