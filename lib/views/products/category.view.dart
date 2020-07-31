import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/category.controller.dart';
import 'package:venda_mais_client_buy/models/entities/category.entities.dart';
import 'package:venda_mais_client_buy/views/products/categorys_tile.dart';


class CategoryView extends StatelessWidget {
  final _controller = new CategoryController();
  final String idSegment;

  CategoryView(this.idSegment);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[ Flexible(
        child: FutureBuilder<List<CategoryData>>(
      future: _controller.getAll(idSegment),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          return Container(
              height: 100.0,
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return CategoryTileView(snapshot.data[index]);
                    },
                  )),
                ],
              ));
        }
      },
    ))],);
  }
}
