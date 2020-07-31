import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/product.controller.dart';
import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';
import 'package:venda_mais_client_buy/view_model/products.view.model.dart';
import 'package:venda_mais_client_buy/views/products/product.tile.view.dart';
import 'package:venda_mais_client_buy/views/widgets/connect.fail.dart';

class ProductTabView extends StatefulWidget {
  final MenuData data;
  final String idEstablishment;
  final String search;
  ProductTabView(this.data, this.idEstablishment, this.search);
  @override
  _ProductTabViewState createState() => _ProductTabViewState(this.data, this.idEstablishment, this.search);
}

class _ProductTabViewState extends State<ProductTabView> {
  final MenuData data;
  final String idEstablishment;
  final String search;
  final ProductController _controller = new ProductController();

  _ProductTabViewState(this.data, this.idEstablishment, this.search);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductsViewModel>(
        future: _controller.getAll(idEstablishment, data, search),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.data.checkConnect) {
            return Center(child: ConnectFail(_onRefresh));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.list.length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ProductTileView(snapshot.data.list[index], idEstablishment, data.id);
                });
          }
        });
  }

  _onRefresh(){
    setState(() {});
  }

}