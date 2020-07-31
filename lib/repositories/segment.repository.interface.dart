import 'package:venda_mais_client_buy/models/entities/segments.entities.dart';

abstract class ISegmentRepository {
  Future<List<SegmentData>> getAll();
}