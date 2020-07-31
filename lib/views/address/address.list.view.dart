import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:venda_mais_client_buy/views/address/address.tile.view.dart';
import 'package:venda_mais_client_buy/views/address/address.tab.view.dart';
import 'package:venda_mais_client_buy/views/cartproducts/cart.view.dart';
import 'package:venda_mais_client_buy/views/home.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class AddressListView extends StatelessWidget {
  final ModuleEnum module;
  AddressListView(this.module);

  @override
  Widget build(BuildContext context) {
    var userStore = Provider.of<UserStore>(context);
    return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('Adicionar Endereços'),
              centerTitle: true,
            ),
            body: Observer(
              builder: (context) {
                if (userStore.isLoading)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  return Column(children: <Widget>[
                    Expanded(
                        child: ListView(
                          children: <Widget>[
                            Column(
                              children: userStore.user.addressList.map((address) {
                                return AddressTileView(address, module);
                              }).toList(),
                            ),
                            Divider(),
                            Card(
                                child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => AddressTabView()));
                                      },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.add,
                                          size: 30,
                                          color: WidgetsCommons.buttonColor(),
                                        ),
                                        Text(
                                          "Endereço",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    )
                                )
                            ),
                            Divider(),
                          ],
                        )
                    ),
                  ]);
                }
                },
            )
        );

  }
}
