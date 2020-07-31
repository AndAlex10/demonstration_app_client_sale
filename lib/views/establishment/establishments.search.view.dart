import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/establishment.controller.dart';
import 'package:venda_mais_client_buy/models/entities/segments.entities.dart';
import 'package:venda_mais_client_buy/view_model/establishments.view.model.dart';
import 'package:venda_mais_client_buy/views/establishment/establishment.menu.view.dart';
import 'package:venda_mais_client_buy/views/establishment/establishments.tile.view.dart';
import 'package:venda_mais_client_buy/views/widgets/connect.fail.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class EstablishmentSearchView extends StatefulWidget {
  final SegmentData data;
  EstablishmentSearchView(this.data);

  @override
  _EstablishmentSearchViewState createState() =>
      _EstablishmentSearchViewState(this.data);
}

class _EstablishmentSearchViewState extends State<EstablishmentSearchView> {
  final SegmentData data;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = EstablishmentController();
  String _search = "";

  _EstablishmentSearchViewState(this.data);

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(data.name),
          centerTitle: true,
        ),
        key: _scaffoldKey,
        body: Observer(builder: (_) {
            if (store.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Digite aqui o que procura',
                          labelStyle: TextStyle(
                              color: Colors.black, fontStyle: FontStyle.italic),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                        textAlign: TextAlign.center,
                        onSubmitted: (text) {
                          setState(() {
                            _search = text;
                            //_ListAddress(text);
                          });
                        },
                      ),
                    ),
                    Expanded(
                        child: FutureBuilder<EstablishmentsViewModel>(
                      future:
                          _controller.getWithFilterName(this.data.id, _search, store.user),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot.data.checkConnect) {
                          return Center(child: ConnectFail(onRefreshConnect));
                        } else {
                          return Form(
                            child: Column(
                              //padding: EdgeInsets.all(10.0),
                              children: <Widget>[
                                Expanded(
                                    child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.list.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EstablishmentsMenuView(
                                                          snapshot
                                                              .data.list[index])));
                                        },
                                        child: EstablishmentTileView(
                                            snapshot.data.list[index]));
                                  },
                                )),
                              ],
                            ),
                          );
                        }
                      },
                    ))
                  ],
                ),
              );
            }
          },
        ));
  }

  void onRefreshConnect(){
    setState(() { });
  }
}
