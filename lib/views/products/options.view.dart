import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/product.controller.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';

class OptionsView extends StatelessWidget {
  final _controller = new ProductController();
  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    return cartStore.productCurrent.optionsList.length > 0
        ? Column(
            children: <Widget>[
              Divider(),
              Text(
                "Escolha uma opção (obrigatório)",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
              Divider(),
              getOptions(cartStore),
              //_radioOptions(),
              Divider(),
            ],
          )
        : SizedBox();
  }

  getOptions(CartStore cartStore) {
    return Column(
      children: <Widget>[
        ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(8.0),
            children: cartStore.productCurrent.optionsList
                .map((op) => RadioListTile(
                      activeColor: WidgetsCommons.buttonColor(),
                      groupValue: op.check ? op.hashCode : 0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${op.title}"),
                          Text(
                            "R\$ " + op.price.toStringAsFixed(2),
                            style:
                                TextStyle(fontSize: 17.0, color: Colors.green),
                          ),
                        ],
                      ),
                      value: op.hashCode,
                      onChanged: (val) {
                        cartStore.checkOption(val);
                        cartStore.setAmountProduct(_controller
                            .recalculateValue(cartStore.productCurrent));
                      },
                    ))
                .toList())
      ],
    );
  }
}
