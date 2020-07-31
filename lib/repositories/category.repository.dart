
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/category.entities.dart';
import 'package:venda_mais_client_buy/repositories/category.repository.interface.dart';

class CategoryRepository implements ICategoryRepository {

  @override
  Future<List<CategoryData>> getAll(String idSegment) async{
    List<CategoryData> list = [];
    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(idSegment)
        .collection("???")
        .orderBy("order")
        .getDocuments();

    CategoryData data;
    for (var i = 0; i < snapshot.documents.length; i++) {
      data = CategoryData.fromDocument(snapshot.documents[i]);

      list.add(data);
    }

    return list;
  }
}