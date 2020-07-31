import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/segment.controller.dart';
import 'package:venda_mais_client_buy/view_model/segment.view.model.dart';
import 'package:venda_mais_client_buy/views/establishment/segment.tile.view.dart';
import 'package:venda_mais_client_buy/views/widgets/connect.fail.dart';

class SegmentsView extends StatefulWidget {
  @override
  _SegmentsViewState createState() => _SegmentsViewState();
}

class _SegmentsViewState extends State<SegmentsView> {
  final _controller = new SegmentController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SegmentViewModel>(
      future: _controller.getAll(),
      builder: (context, segments) {
        if (!segments.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!segments.data.checkConnect) {
          return Center(child: ConnectFail(_refresh));
        } else
          return GridView.builder(
              padding: EdgeInsets.all(2.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: 0.90,
              ),
              itemCount: segments.data.list.length,
              itemBuilder: (context, index) {
                return SegmentTileView(segments.data.list[index]);
              });
      },
    );
  }

  _refresh() {
    setState(() {});
  }
}
