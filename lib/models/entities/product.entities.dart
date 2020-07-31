import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/models/entities/options.entities.dart';

class ProductData {

  String category;
  String id;
  String title;
  String description;
  double price;
  bool active;
  bool additional;
  bool options;
  String idOptionSelect;
  String image;


  List images;

  List<Additional> additionalList = [];

  List<OptionsData> optionsList = [];

  ProductData();

  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"] + 0.0;
    active = snapshot.data["active"];
    additional = snapshot.data["additional"];
    image = snapshot.data["image"];
    if (additional == null){
      additional = false;
    }

    if (snapshot.data["images"] != null) {
      images = snapshot.data["images"];
    } else {
      images = [];
    }

    options = snapshot.data["options"];
    if (options == null) {
      options = false;
    }

  }

  checkOption(int hash){
    for (OptionsData option in optionsList){
      if(option.hashCode == hash){
        option.check = true;
      } else {
        option.check = false;
      }
    }
  }


  Map<String, dynamic> toMap(){
    for (OptionsData option in optionsList){
      if(option.check == true){
        idOptionSelect  = option.id;
        price = option.price;
      } else {
        option.check = false;
      }
    }

    return {
      "title": title,
      "description": description,
      "price": price,
      "active": active,
      "additional": toMapAdditionalList(),
      "idOptionSelect": idOptionSelect

    };
  }

  List<Map<String, dynamic>> toMapAdditionalList(){
    List<Map<String, dynamic>> listMap = [];
    for (var h = 0; h < additionalList.length; h++) {
      Additional additional = additionalList[h];
      if (additional.check) {
        listMap.add(additional.toMap());
      }
    }

    return listMap;
  }


  List<Additional> toAdditionalList(){
    List<Additional> list = [];
    for (var h = 0; h < additionalList.length; h++) {
      Additional additional = additionalList[h];
      if (additional.check) {
        list.add(additional);
      }
    }

    return list;
  }

}
