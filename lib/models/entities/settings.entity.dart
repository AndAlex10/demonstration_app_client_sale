
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsData {
  String urlMQ;
  String userMQ;
  String passwordMQ;

  SettingsData.fromDocument(DocumentSnapshot document){
    urlMQ = document.data['url'];
    userMQ = document.data['username'];
    passwordMQ = document.data['password'];
  }
}