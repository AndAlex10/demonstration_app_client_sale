import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/menu.controller.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/view_model/menu.view.model.dart';
import 'package:venda_mais_client_buy/views/establishment/establishments.tile.view.dart';
import 'package:venda_mais_client_buy/views/products/menu.tile.view.dart';
import 'package:venda_mais_client_buy/views/cartproducts/cart.button.view.dart';
import 'package:venda_mais_client_buy/views/widgets/connect.fail.dart';

class EstablishmentsMenuView extends StatefulWidget {
  final EstablishmentData data;

  EstablishmentsMenuView(this.data);

  @override
  _EstablishmentsMenuViewState createState() =>
      _EstablishmentsMenuViewState(this.data);
}

class _EstablishmentsMenuViewState extends State<EstablishmentsMenuView> {
  final EstablishmentData data;
  final MenuController _menuController = new MenuController();

  _EstablishmentsMenuViewState(this.data);

  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(data.name),
          centerTitle: true,
        ),
        floatingActionButton: CartButtonView(),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              EstablishmentTileView(data),
              Padding(
                padding: EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 4.0),
                child: Container(
                    height: 50.0,
                    child: Card(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'O que procura?',
                            labelStyle: TextStyle(
                                color: Colors.black45, fontStyle: FontStyle.italic),
                            border: OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                            ),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                          textAlign: TextAlign.center,
                          onSubmitted: (text) {
                            setState(() {
                              _search = text;
                              //_ListAddress(text);
                            });
                          },
                        ))),
              ),
              SizedBox(
                height: 5.0,
              ),
              Flexible(
                  child: FutureBuilder<MenuViewModel>(
                    future: _menuController.getAll(data.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (!snapshot.data.checkConnect) {
                        return Center(child: ConnectFail(onRefreshConnect));
                      } else {
                        return Container(
                          child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.list.length,
                                        itemBuilder: (context, index) {
                                          return MenuTileView(
                                              snapshot.data.list[index], data.id, _search);
                                        },
                                      )
                                  ),
                                ],
                              )
                          ),
                        );
                      }
                    },
                  )
              )
            ]
        )
    );
  }

  void onRefreshConnect() {
    setState(() {});
  }
}
