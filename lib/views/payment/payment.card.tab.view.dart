import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/views/payment/payment.card.create.view.dart';
import 'package:venda_mais_client_buy/views/payment/payment.card.tile.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:provider/provider.dart';

class PaymentCardTabView extends StatelessWidget {
  final ModuleEnum module;

  PaymentCardTabView(this.module);

  @override
  Widget build(BuildContext context) {
    var userStore = Provider.of<UserStore>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Formas de Pagamento'),
          centerTitle: true,
        ),
        body: Observer( name: "PaymentCard",
          builder: (_) {
            if (userStore.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(children: <Widget>[
                Expanded(
                    child: ListView(children: <Widget>[
                      Column(
                      children: userStore.user.paymentList.map((payment) {
                        return PaymentCardTileView(payment, module);
                      }).toList(),
                      ),
                      Divider(),
                      Card(
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentCardCreateView()));
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
                                  "Cartão de Crédito",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ))),
                      Divider(),
                  ],
                )),
              ]);
            }
          },
        ));
  }
}
