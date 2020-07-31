
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.interface.dart';

class AddressRepository implements IAddressRepository {

  @override
  Future<List<Address>> load(String idUser) async {
    List<Address> addressList = [];
    Address address;
    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(idUser)
        .collection("???")
        .orderBy("order")
        .getDocuments();
    if (snapshot.documents != null) {
      for (DocumentSnapshot doc in snapshot.documents) {
        address = Address.fromDocument(doc);

        addressList.add(address);
      }
    }

    return addressList;
  }

  @override
  Future<Null> alter(UserEntity userEntity, Address address) async {
    Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .updateData(userEntity.toMap());

    Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .collection('???')
        .document(address.id)
        .updateData(address.toMap());

  }

  @override
  Future<Null> remove(UserEntity userEntity, Address address) async {
    Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .collection('???')
        .document(address.id)
        .delete();
    userEntity.addressList.remove(address);
  }

  Future<Null> add(UserEntity userEntity, Address address) async {
    Map data = address.toMap();
    await Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .collection('???')
        .add(data);
  }

  @override
  Future<Null> setDefault(UserEntity userEntity, Address address) async {
      await Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .collection('???')
        .document(address.id)
        .updateData(address.toMap());

  }

  @override
  Future<Null> setUnDefault(String id, Address address) async {
    await Firestore.instance
        .collection("???")
        .document(id)
        .collection('???')
        .document(address.id)
        .updateData(address.toMap());

  }
}