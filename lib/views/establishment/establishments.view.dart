import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/establishment.controller.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/entities/segments.entities.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:venda_mais_client_buy/enums/segment.type.enum.dart';
import 'package:venda_mais_client_buy/view_model/establishments.view.model.dart';
import 'package:venda_mais_client_buy/views/address/address.list.view.dart';
import 'package:venda_mais_client_buy/views/establishment/address.establishments.view.dart';
import 'package:venda_mais_client_buy/views/establishment/establishment.menu.view.dart';
import 'package:venda_mais_client_buy/views/establishment/establishments.search.view.dart';
import 'package:venda_mais_client_buy/views/establishment/establishments.tile.view.dart';
import 'package:venda_mais_client_buy/views/products/category.view.dart';
import 'package:venda_mais_client_buy/views/user/login.view.dart';
import 'package:venda_mais_client_buy/views/widgets/connect.fail.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class EstablishmentsTabView extends StatefulWidget {
  final SegmentData data;
  EstablishmentsTabView(this.data);

  @override
  _EstablishmentsTabViewState createState() =>
      _EstablishmentsTabViewState(this.data);
}

class _EstablishmentsTabViewState extends State<EstablishmentsTabView> {
  final SegmentData data;
  final _controller = new EstablishmentController();
  List<EstablishmentData> dataList = [];

  _EstablishmentsTabViewState(this.data);

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return
      !store.isLoggedIn() ? LoginView(false) :
      store.isNotAddress() ? AddressListView(ModuleEnum.ESTABLISHMENT) :
      Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          title: Text(data.name),
          centerTitle: true,
        ),
        body:Observer(builder: (_) {
          if (store.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AddressSelectView(),
          Expanded(
          child:ListView(
            scrollDirection: Axis.vertical,
                    children: <Widget>[
                      data.icon.toUpperCase() == SegmentType.RESTAURANT ? Divider(): SizedBox(),
                      data.icon.toUpperCase() == SegmentType.RESTAURANT ? CategoryView(data.id): SizedBox(),
                      data.icon.toUpperCase() == SegmentType.RESTAURANT ? Divider(): SizedBox(),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                          child: SizedBox(
                            height: 40.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.black12)),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.search),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "O que está procurando?",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              textColor: Colors.black38,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EstablishmentSearchView(data)));
                              },
                            ),
                          )),

                      SizedBox(height: 8.0,),
                      FutureBuilder<EstablishmentsViewModel>(
                            future: _controller.getAll(
                                data.id, store.category, store.user),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!snapshot.data.checkConnect) {
                                return Center(child: ConnectFail(onRefresh));
                              } else {
                                return ListView.builder(
                                  physics: new NeverScrollableScrollPhysics(),
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
                                );

                              }
                            },
                          ),
                    ],
                  )),

                ]);
          }
        }));
  }

  void onRefresh(){
    setState(() { });
  }
}
