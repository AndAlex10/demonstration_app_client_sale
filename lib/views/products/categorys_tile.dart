import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/models/entities/category.entities.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:provider/provider.dart';

class CategoryTileView extends StatelessWidget {
  final CategoryData data;
  CategoryTileView(this.data);

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return InkWell(
      onTap: () {
        store.setCategory(data.id);
      },
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2.0),
                  width: 80.0,
                  child: Image.network(
                    data.image,
                    width: 90,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  " ${data.name} ",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
              ],
            )),
        shape: RoundedRectangleBorder(
            side: new BorderSide(
                color: store.category == data.id ? WidgetsCommons.buttonColor() : Colors.white,
                width: 2.0)),
      ),
    );
  }
}
