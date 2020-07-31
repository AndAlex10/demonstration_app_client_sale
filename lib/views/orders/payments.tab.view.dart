import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:venda_mais_client_buy/controllers/payment.delivery.controller.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/view_model/payments.delivery.view.model.dart';
import 'package:venda_mais_client_buy/views/orders/payments.tile.view.dart';
import 'package:venda_mais_client_buy/views/payment/payment.card.create.view.dart';
import 'package:venda_mais_client_buy/views/payment/payment.card.tile.view.dart';
import 'package:venda_mais_client_buy/views/widgets/connect.fail.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:provider/provider.dart';

class PaymentsView extends StatefulWidget {
  final String idEstablishment;
  PaymentsView(this.idEstablishment);

  @override
  _PaymentsViewState createState() => _PaymentsViewState(this.idEstablishment);
}

class _PaymentsViewState extends State<PaymentsView> {
  final String idEstablishment;
  final _controller = new PaymentDeliveryController();
  _PaymentsViewState(this.idEstablishment);

  @override
  Widget build(BuildContext context) {
    var userStore = Provider.of<UserStore>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Formas de Pagamento'),
          centerTitle: true,
        ),
        body: Observer(builder: (_) {
            if (userStore.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return Card(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListView(children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Pague pelo Aqui Tem',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                        Divider(),
                        Column(
                          children:
                          userStore.user.paymentList.map((payment) {
                            return PaymentCardTileView(payment, ModuleEnum.CART);
                          }).toList(),
                        ),
                        SizedBox(
                          height: 10.0,
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
                                          color: Colors.black54, fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ))),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Pagamento na entrega',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                        Divider(),
                        Column(
                          children: <Widget>[
                            FutureBuilder<PaymentsDeliveryViewModel>(
                              future: _controller.getAll(this.idEstablishment),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (!snapshot.data.checkConnect) {
                                  return Center(child: ConnectFail(_onRefresh));
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: new NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.list.length,
                                    itemBuilder: (context, index) {
                                      return PaymentsDeliveryTileView(
                                          snapshot.data.list[index]);
                                    },
                                  );
                                }
                              },
                            )
                          ],
                        )
                      ])));
            }
          },
        ));
  }

  _onRefresh(){
    setState(() { });
  }

}
