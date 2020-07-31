import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/segment.controller.dart';
import 'package:venda_mais_client_buy/models/entities/segments.entities.dart';
import 'package:venda_mais_client_buy/repositories/segment.repository.dart';
import 'package:venda_mais_client_buy/repositories/segment.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/segment.view.model.dart';

class SegmentRepositoryMock extends Mock implements SegmentRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  SegmentController controller;
  ConnectComponent connect;
  ISegmentRepository repository;
  setUp(() {
    repository = SegmentRepositoryMock();
    connect = MockConnect();
    controller = SegmentController.tests(repository, connect);
  });

  group('SegmentController', ()
  {
    test("getAll", () async {
      List<SegmentData> list = [];
      SegmentData data = new SegmentData();
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getAll()).thenAnswer((_) async =>
          Future.value(list));
      SegmentViewModel response = await controller.getAll();
      expect(response.list.length == 1, true);
    });


    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      SegmentViewModel response = await controller.getAll();
      expect(response.list.length == 0, true);
    });
  });

}