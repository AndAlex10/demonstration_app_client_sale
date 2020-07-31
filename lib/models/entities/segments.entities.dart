
import 'package:cloud_firestore/cloud_firestore.dart';

class SegmentData {
  String id;
  String name;
  String icon;
  String image;
  int order;

  SegmentData({this.id, this.name, this.icon, this.image, this.order});

  factory SegmentData.fromDocument(DocumentSnapshot document){
    return SegmentData(id: document.documentID, name: document.data['name'], icon: document.data['icon'], image: document.data['imgUrl'],
        order: document.data['order']);
  }
}

