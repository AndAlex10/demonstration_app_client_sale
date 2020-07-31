import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/coupon.controller.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';

class DiscountCardView extends StatelessWidget {
  final CouponController _controller = new CouponController();

  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu cupom"
              ),
              initialValue:  cartStore.coupon == null ? "" : cartStore.coupon.code,
              onFieldSubmitted: (code) async{
                 await _controller.get(code, cartStore).then((result){
                   if (result.success) {
                     Scaffold.of(context).showSnackBar(
                         SnackBar(content: Text("Cupom Adicionado!"),
                           backgroundColor: Colors.green,));
                   } else {
                     Scaffold.of(context).showSnackBar(
                         SnackBar(content: Text(result.message),
                           backgroundColor: Colors.redAccent,));
                   }
                 });

              },
            ),
          )
        ],
      ),
    );
  }

}
