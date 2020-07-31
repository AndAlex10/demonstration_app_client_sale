
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/settings.entity.dart';
import 'package:venda_mais_client_buy/repositories/settings.repository.interface.dart';

class SettingsRepository implements ISettingsRepository {
  @override
  Future<SettingsData> getManagerServer() async{
    DocumentSnapshot snapshot = await Firestore.instance.collection("???").document("???").get();

    SettingsData settingsData = SettingsData.fromDocument(snapshot);
    return settingsData;
  }
}