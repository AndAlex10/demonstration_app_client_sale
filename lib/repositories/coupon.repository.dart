import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/coupon.entities.dart';
import 'package:venda_mais_client_buy/repositories/coupon.repository.interface.dart';

class CouponRepository implements ICouponRepository {

  @override
  Future<Coupon> get(String code, String idEstablishment) async{
    Coupon coupon;
    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(idEstablishment)
        .collection("???")
        .where("code", isEqualTo: code)
        .getDocuments();

    if (snapshot.documents.length > 0){
      for (DocumentSnapshot doc in snapshot.documents) {
        coupon = Coupon.fromDocument(doc);

        if (DateTime.now().isAfter(coupon.dateExpiration.toDate())){
          coupon = null;
        }
      }


    }


    return coupon;
  }
}