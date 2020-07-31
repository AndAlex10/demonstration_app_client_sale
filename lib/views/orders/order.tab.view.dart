import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/views/orders/order.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class OrdersTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: new PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: new Container(
                height: 50.0,
                child: new TabBar(
                  indicatorColor: WidgetsCommons.buttonColor(),
                  labelColor: Colors.black87,
                  labelStyle:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(
                      //    icon: Icon(Icons.grid_on),
                      text: 'Andamento',
                    ),
                    Tab(
                      //   icon: Icon(Icons.list),
                      text: 'Finalizados',
                    ),
                  ],
                ),
              ),
            ),
            body: Observer(builder: (_) {
              if (store.isLoading)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (!store.isLoggedIn()) {
                return Center(child: Text("Usuário não logado!"));
              } else {
                return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      OrdersView(0),
                      OrdersView(1),
                    ]);
              }
            })));
  }
}
