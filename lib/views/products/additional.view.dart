import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/views/products/additional.tile.view.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:provider/provider.dart';

class AdditionalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    return cartStore.productCurrent.additional
        ? Column(
            children: <Widget>[
              Divider(),
              ExpansionTile(
                initiallyExpanded: false,
                title: Text(
                  "Adicionais (opcional)",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                ),
                children: _buildExpandableAdditional(cartStore.productCurrent.additionalList),
              ),
              Divider(),
            ],
          )
        : SizedBox();
  }

  _buildExpandableAdditional(List<Additional> list) {
    List<Widget> columnContent = [];
    for (Additional add in list)
      columnContent.add(AdditionalTileView(add));
    return columnContent;
  }
}
