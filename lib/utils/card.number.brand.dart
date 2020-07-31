import 'package:enum_to_string/enum_to_string.dart';
import 'package:venda_mais_client_buy/enums/brand.enum.dart';

class CardBrand {
  static final visa = RegExp(r'^4[0-9]{12}(?:[0-9]{3})');
  static final master = RegExp(r'^5[1-5][0-9]{14}');
  static final diners = RegExp(r'^3(?:0[0-5]|[68][0-9])[0-9]{11}');
  static final hiperCard = RegExp(r'^(606282\d{10}(\d{3})?)|(3841\d{15})');
  static final elo = RegExp(r'^(40117(8|9))|(431274)|(438935)|(451416)|(457393)|(45763(1|2))|(504175)|(627780)|(636297)|(636368)|(65500(0|1))|(65165[2-4])|(65048[5-8])|(65500(2|3))|(650489)|(65049[0-4])|(506699|5067[0-6][0-9]|50677[0-8])|(509[0-8][0-9]{2}|5099[0-8][0-9]|50999[0-9])|(65003[1-3])|(65003[5-9]|65004[0-9]|65005[01])|(65040[5-9]|6504[1-3][0-9])|(65048[5-9]|65049[0-9]|6505[0-2][0-9]|65053[0-8])|(65054[1-9]|6505[5-8][0-9]|65059[0-8])|(65070[0-9]|65071[0-8])|(65072[0-7])|(65090[1-9]|65091[0-9]|650920)|(65165[2-9]|6516[67][0-9])|(65500[0-9]|65501[0-9])|(65502[1-9]|6550[34][0-9]|65505[0-8])');
  static final amex = RegExp(r'^3[47][0-9]{13}');

  static String getBrand(String number){

    if(elo.hasMatch(number)){
      return "Elo";
    }

    if(hiperCard.hasMatch(number)){
      return "Hipercard";
    }

    if(diners.hasMatch(number)){
      return "Diners";
    }

    if(amex.hasMatch(number)){
      return "Amex";
    }

    if(master.hasMatch(number)){
      return "Master";
    }

    if(visa.hasMatch(number)){
      return "Visa";
    }

    return null;
  }


  static String getBrandImage(String brand){
    if(brand.toUpperCase() == EnumToString.parse(BrandType.VISA)){
      return 'images/methodspayment/visa.png';
    }

    if(brand.toUpperCase() == EnumToString.parse(BrandType.MASTER)){
      return 'images/methodspayment/master.png';
    }

    if(brand.toUpperCase() == EnumToString.parse(BrandType.ELO)){
      return 'images/methodspayment/elo.png';
    }

    if(brand.toUpperCase() == EnumToString.parse(BrandType.HIPERCARD)){
      return 'images/methodspayment/hipercard.png';
    }

    if(brand.toUpperCase() == EnumToString.parse(BrandType.DINERS)){
      return 'images/methodspayment/diners.png';
    }

    if(brand.toUpperCase() == EnumToString.parse(BrandType.AMEX)){
      return 'images/methodspayment/amex.png';
    }


    return null;
  }
}