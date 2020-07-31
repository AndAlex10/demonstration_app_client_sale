import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:venda_mais_client_buy/controllers/rating.order.controller.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';

class RatingOrderView extends StatefulWidget {
  final OrderData order;

  RatingOrderView(this.order);

  @override
  _RatingOrderViewState createState() => _RatingOrderViewState(this.order);
}

class _RatingOrderViewState extends State<RatingOrderView> {
  final OrderData order;

  _RatingOrderViewState(this.order);

  RatingOrderController _controller = new RatingOrderController();

  final int starCount = 5;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Avaliação"),
        centerTitle: true,
      ),
      body: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
              SizedBox(height: 45.0,),
              Text(
                'Avalie seu pedido',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
              ),
              Padding(
                padding: new EdgeInsets.only(
                  top: 15.0,
                ),
                child: new StarRating(
                  size: 50.0,
                  rating: this.order.rating,
                  color: Colors.orange,
                  borderColor: Colors.grey,
                  starCount: starCount,
                  onRatingChanged: (rating) => setState(
                    () {
                      this.order.rating = rating;
                    },
                  ),
                ),
              ),
              new Text(
                "Sua classificação é: ${this.order.rating}",
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 12.0,),
              ),
              SizedBox(height: 45.0,),
              SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    child: Text(
                      "Avaliar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: WidgetsCommons.buttonColor(),
                    onPressed: () async {
                      await _controller.save(order).then((val){
                        if(val.success) {
                          WidgetsCommons.onSucess(_scaffoldKey,
                              'Avaliação realizada! Agradeçemos!');
                          Future.delayed(Duration(seconds: 3)).then((_) {
                            Navigator.of(context).pop();
                          });
                        } else {
                          WidgetsCommons.onFail(_scaffoldKey, val.message);
                        }
                      });

                    },
                  )),
            ])),
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black12, width: 2.0)),
      ),
    );
  }
}
