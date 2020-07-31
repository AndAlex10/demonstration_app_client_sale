import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/product.controller.dart';
import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:provider/provider.dart';

class AdditionalTileView extends StatelessWidget {
  final Additional data;
  final _controller = new ProductController();
  AdditionalTileView(this.data);

  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    return Card( child:
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
    Checkbox(
          activeColor: WidgetsCommons.buttonColor(),
          value: data.check,
          onChanged: (bool value) {
            data.check = value;
            cartStore.setAmountProduct(_controller.recalculateValue(cartStore.productCurrent));
          },
        ),
        Expanded(child: Text(data.title, style: TextStyle(fontSize: 17.0, color: Colors.black),)),
        Text("R\$ " + data.price.toStringAsFixed(2), style: TextStyle(fontSize: 17.0, color: Colors.green),),
        SizedBox(width: 5.0,)

      ],)
    );
  }
}

