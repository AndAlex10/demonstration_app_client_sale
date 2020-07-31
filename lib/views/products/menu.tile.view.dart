import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';
import 'package:venda_mais_client_buy/views/products/products.tab.view.dart';

class MenuTileView extends StatelessWidget {
  final MenuData data;

  final String idEstablishment;

  final String search;

  MenuTileView(this.data, this.idEstablishment, this.search);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            SizedBox(height: 10.0,),
            Text(
              " ${data.name} ",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            SizedBox(height: 10.0,),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
            ProductTabView(data, idEstablishment, search),
            SizedBox(
              height: 10.0,
            ),
          ],
        ));
  }

}
