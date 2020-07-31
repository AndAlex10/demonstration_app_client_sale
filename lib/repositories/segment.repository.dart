
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/segments.entities.dart';
import 'package:venda_mais_client_buy/repositories/segment.repository.interface.dart';

class SegmentRepository implements ISegmentRepository {

  @override
  Future<List<SegmentData>> getAll() async{
    List<SegmentData> list = [];
    QuerySnapshot snapshot = await Firestore.instance.collection("???").orderBy("order").getDocuments();

    SegmentData data;
    for (DocumentSnapshot doc in snapshot.documents) {
      data = SegmentData.fromDocument(doc);

      list.add(data);
    }

    return list;
  }
}