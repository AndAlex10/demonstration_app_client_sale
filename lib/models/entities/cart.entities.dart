import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/models/entities/options.entities.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';

class CartProduct {

  String cid;

  String idEstablishment;
  String category;
  String pid;

  String obs;

  int quantity;

  double amount;

  ProductData productData;

  List<Additional> additionalData;

  CartProduct();


  Map<String, dynamic> toMap(){
    return {
      "idEstablishment": idEstablishment,
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "amount": amount,
      "product": productData.toMap(),
      "additional": productData.toMapAdditionalList()
    };
  }

  String getListTextAdditionals() {
    String text = "";
    for (var h = 0; h < additionalData.length; h++) {
      Additional additional = additionalData[h];
      text += "- ${additional.title} \n";
    }
    return text;
  }

  String getOptionSelected() {
    String text = "";
    for (var h = 0; h < productData.optionsList.length; h++) {
      OptionsData optionsData = productData.optionsList[h];
      if(optionsData.check) {
        text += "- ${optionsData.title} \n";
      }
    }
    return text;
  }

}