import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/order.controller.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/view_model/order.view.model.dart';
import 'package:venda_mais_client_buy/views/orders/order.tile.view.dart';
import 'package:venda_mais_client_buy/views/widgets/connect.fail.dart';
import 'package:provider/provider.dart';

class OrdersView extends StatefulWidget {
  final int indexTab;
  OrdersView(this.indexTab);
  @override
  _OrdersViewState createState() => _OrdersViewState(this.indexTab);
}

class _OrdersViewState extends State<OrdersView> {
  final int indexTab;
  final OrderController _controller = new OrderController();
  _OrdersViewState(this.indexTab);

  @override
  Widget build(BuildContext context) {
    var userStore = Provider.of<UserStore>(context);
      return FutureBuilder<OrderViewModel>(
        future: _controller.getAllUser(userStore.user.id, this.indexTab),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.data.checkConnect) {
            return Center(child: ConnectFail(onRefreshConnect));
          } else {
            return ListView(
              children: snapshot.data.list.map((data) => OrderTileView(data)).toList()
              ,
            );
          }
        },
      );

  }


  void onRefreshConnect(){
    setState(() { });
  }
}
