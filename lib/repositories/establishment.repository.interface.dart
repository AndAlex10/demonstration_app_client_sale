import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';

abstract class IEstablishmentRepository {

  Future<List<EstablishmentData>> getWithFilterName(String idSegment, String text, String city, String state);

  Future<EstablishmentData> getId(String idEstablishment) ;

  Future<List<EstablishmentData>> getAll(String idSegment, String idCategory, String city, String state);

  Future<Null> updateSequence(String idEstablishment, int seq);
}