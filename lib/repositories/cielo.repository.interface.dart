import 'dart:async';
import 'package:venda_mais_client_buy/models/entities/cielo.entities.dart';


abstract class ICieloRepository {

  Future<CieloData> get();

}