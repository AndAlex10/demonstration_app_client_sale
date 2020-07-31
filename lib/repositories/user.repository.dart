import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.interface.dart';

class UserRepository implements IUserRepository {

  @override
  Future<Null> create(UserEntity userEntity) async {
    await Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .setData(userEntity.toMap());
  }

  @override
  Future<bool> save(UserEntity userEntity) async {
    await Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .setData(userEntity.toMap())
        .then((data) async {})
        .catchError((e) {
      return false;
    });

    return true;
  }

  @override
  Future<UserEntity> load() async {
    UserEntity userEntity;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser;

    if (firebaseUser == null) {
      firebaseUser = await auth.currentUser();
    }
    if (firebaseUser != null) {
      DocumentSnapshot docUser = await Firestore.instance
          .collection("???")
          .document(firebaseUser.uid)
          .get();

      if(docUser.data != null) {
        userEntity = UserEntity.fromMap(docUser.data);
        userEntity.id = docUser.documentID;
      }
    }

    return userEntity;
  }

}
