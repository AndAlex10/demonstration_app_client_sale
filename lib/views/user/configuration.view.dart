import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:venda_mais_client_buy/views/address/address.list.view.dart';
import 'package:venda_mais_client_buy/views/payment/payment.card.tab.view.dart';
import 'package:venda_mais_client_buy/views/user/about.view.dart';
import 'package:venda_mais_client_buy/views/user/login.view.dart';
import 'package:venda_mais_client_buy/views/user/user.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class ConfigurationTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return Scaffold(body: Observer(builder: (_) {
        if (store.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (!store.isLoggedIn()) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'Entrar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  textColor: Colors.white,
                  color: WidgetsCommons.buttonColor(),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginView(false)));
                  },
                )
              ],
            ),
          );
        } else
          return ListView(
            children: <Widget>[
              Card(
                  shape: RoundedRectangleBorder(
                      side: new BorderSide(color: Colors.black12, width: 2.0)),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                      height: 90.0,
                      child:  Row(
                    children: <Widget>[
                      store.user.photo != null ? Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new NetworkImage(
                                      store.user.photo)))) : WidgetsCommons.noPhoto(),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                          child: Text(
                        store.user.name,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                  ))),
              WidgetsCommons.optionTileButton(context, "Meus Dados", UserView(false),
                  Icon(Icons.person_outline, size: 24.0)),
              WidgetsCommons.optionTileButton(context, "Meus Endereços", AddressListView(ModuleEnum.CONFIGURATION),
                  Icon(Icons.location_on, size: 24.0)),
              WidgetsCommons.optionTileButton(context, "Formas de Pagamento", PaymentCardTabView(ModuleEnum.CONFIGURATION),
                  Icon(Icons.payment, size: 24.0)),
              WidgetsCommons.optionTileButton(context, "Sobre", AboutView(),
                  Icon(Icons.info, size: 24.0)),
              SizedBox(
                height: 16.0,
              ),
            ],
          );
      },
    ));
  }
}

