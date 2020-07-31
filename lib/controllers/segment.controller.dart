import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/repositories/segment.repository.dart';
import 'package:venda_mais_client_buy/repositories/segment.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/segment.view.model.dart';

class SegmentController {
  ISegmentRepository repository;
  ConnectComponent connect;

  SegmentController(){
    repository = new SegmentRepository();
    connect = new ConnectComponent();
  }

  SegmentController.tests(this.repository, this.connect);

  Future<SegmentViewModel> getAll() async{
    SegmentViewModel segmentViewModel = new SegmentViewModel();
    segmentViewModel.checkConnect = await connect.checkConnect();
    if(segmentViewModel.checkConnect) {
      segmentViewModel.list = await repository.getAll();
    }

    return segmentViewModel;
  }
}