import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';

class UserEntity {
  String name;
  String email;
  String type;
  String id;
  String photo;
  String phone;
  String addressDefault;
  String paymentDefault;
  int loginType;

  List<Address> addressList = [];
  List<PaymentCard> paymentList = [];

  UserEntity();

  UserEntity.create(this.name, this.email, this.phone);

  UserEntity.fromMap(Map data) {
    this.name = data["name"];
    this.email = data["email"];
    this.type = data["type"];
    this.photo = data["photo"];
    this.phone = data["phone"];
    if (this.phone == null) {
      this.phone = "";
    }
    this.addressDefault = data["addressDefault"] == null ? "" : data["addressDefault"];
    this.paymentDefault = data["paymentDefault"] == null ? "" : data["paymentDefault"];
    this.loginType = data["loginType"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "email": this.email,
      "type": this.type,
      "photo": this.photo,
      "phone": this.phone,
      "addressDefault": this.addressDefault == null ? "" : this.addressDefault,
      "paymentDefault": this.paymentDefault == null ? "" : this.paymentDefault,
      "loginType": this.loginType,
    };
  }
}
