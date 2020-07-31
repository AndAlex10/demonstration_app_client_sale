import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';
import 'package:venda_mais_client_buy/models/entities/options.entities.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';
import 'package:venda_mais_client_buy/repositories/product.repository.interface.dart';

class ProductRepository implements IProductRepository {
  @override
  Future<List<ProductData>> getAll(
      String idEstablishment, MenuData menuData, String search) async {
    List<ProductData> list = [];
    QuerySnapshot snapshot;
    snapshot = await Firestore.instance
          .collection("???")
          .document(idEstablishment)
          .collection("???")
          .document(menuData.id)
          .collection("???")
          .where("active", isEqualTo: true)
          .getDocuments();

    for (DocumentSnapshot doc in snapshot.documents) {
      ProductData productData = ProductData.fromDocument(doc);
      if (productData.additional) {
        productData.additionalList =
            await getAdditional(idEstablishment, menuData);
      }

      if (productData.options) {
        productData.optionsList =
            await getOptions(productData.id, idEstablishment, menuData);
      }
      list.add(productData);
    }

    if (search != '') {
      list = list
          .where((i) => i.title.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    list.sort((a, b) => a.title.compareTo(b.title));
    return list;
  }

  @override
  Future<List<Additional>> getAdditional(
      String idEstablishment, MenuData menuData) async {
    List<Additional> list = [];
    if (menuData.idCategoryAdditional != null) {
      QuerySnapshot snapshot = await Firestore.instance
          .collection("???")
          .document(idEstablishment)
          .collection("???")
          .document(menuData.idCategoryAdditional)
          .collection("???")
          .where("active", isEqualTo: true)
          .getDocuments();

      for (DocumentSnapshot doc in snapshot.documents) {
        Additional additional = Additional.fromDocument(doc);
        additional.category = menuData.idCategoryAdditional;
        list.add(additional);
      }
    }
    return list;
  }

  @override
  Future<List<OptionsData>> getOptions(
      String idProduct, String idEstablishment, MenuData menuData) async {
    List<OptionsData> list = [];
    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(idEstablishment)
        .collection("???")
        .document(menuData.id)
        .collection("???")
        .document(idProduct)
        .collection("options")
        .getDocuments();

    for (DocumentSnapshot doc in snapshot.documents) {
      OptionsData optionsData = OptionsData.fromDocument(doc);
      list.add(optionsData);
    }
    return list;
  }
}
