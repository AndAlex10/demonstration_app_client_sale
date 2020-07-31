import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:venda_mais_client_buy/controllers/address.controller.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:venda_mais_client_buy/views/address/address.detail.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class AddressTileView extends StatelessWidget {
  final ModuleEnum module;
  final Address address;
  final _controller = new AddressController();

  AddressTileView(this.address, this.module);

  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    var userStore = Provider.of<UserStore>(context);
    return InkWell(
      onTap: () async {
        if (module == ModuleEnum.CART) {
          if (_controller.validateAddress(cartStore.establishment, address)) {
            await setDefault(context, userStore);
          } else {
            _infoAddressInvalid(context, cartStore.establishment.name);
          }
        } else {
          await setDefault(context, userStore);
        }

       // Navigator.of(context).pop();
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${address.address}, ${address.number}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${address.neighborhood}',
                      style: TextStyle(
                          color: Colors.black38, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${address.codePostal}',
                      style: TextStyle(
                          color: Colors.black38, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '${address.city} - ${address.state}',
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(
                      'Complemento: ${address.complement}',
                      style: TextStyle(
                          color: Colors.black38, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                _popup(userStore),
              ],
            )),
        shape: addressDefault(),
      ),
    );
  }

  RoundedRectangleBorder addressDefault() {
    if (address.defaultAddress) {
      return RoundedRectangleBorder(
          side: new BorderSide(color: WidgetsCommons.buttonColor(), width: 3.0),
          borderRadius: BorderRadius.circular(4.0));
    } else {
      return RoundedRectangleBorder(
          side: new BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(4.0));
    }
  }

  Widget _popup(UserStore userStore) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddressDetailView(address)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Icon(Icons.edit), Text("Editar")],
                )),
          ),
          PopupMenuItem(
            value: 2,
            child: FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _controller
                      .remove(userStore, address)
                      .then((val) async {
                    if (!val.success) {
                      await WidgetsCommons.message(context, val.message, true);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Icon(Icons.delete), Text("Excluir")],
                )),
          ),
        ],
      );

  _infoAddressInvalid(BuildContext context, String nameEstablishment) async {
    return Alert(
      context: context,
      // type: AlertType.info,
      title: "$nameEstablishment não entrega no endereço selecionado.",
      buttons: [
        DialogButton(
          child: Text(
            "Fechar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: WidgetsCommons.buttonColor(),
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 120,
        )
      ],
    ).show();



  }

  Future<Null> setDefault(BuildContext context, UserStore userStore) async {
    await _controller.setDefault(userStore, address).then((val) async {
      if (!val.success) {
        await WidgetsCommons.message(context, val.message, true);
      }
    });
  }
}
