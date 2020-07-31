import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:venda_mais_client_buy/views/address/address.list.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class AddressSelectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userStore = Provider.of<UserStore>(context);
    return Card(
        child: Container(
          height: 100,
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Endereço de Entrega',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                AddressListView(ModuleEnum.ESTABLISHMENT)));
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: WidgetsCommons.buttonColor(),
                    ),
                    Expanded(
                        child: Text(
                          userStore.addressDefaultName,
                      maxLines: 2,
                    )),
                  ],
                )
              ],
            )));
  }
}
