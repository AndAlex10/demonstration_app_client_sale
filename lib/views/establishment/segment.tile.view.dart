import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/models/entities/segments.entities.dart';
import 'package:venda_mais_client_buy/views/establishment/establishments.view.dart';
class SegmentTileView extends StatelessWidget {

  final SegmentData data;

  SegmentTileView(this.data);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EstablishmentsTabView(data)));
      },
      child: Card(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            AspectRatio(
              aspectRatio: 2.0,
              child: Image.network(
                data.image,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, color:  Colors.black87, fontSize: 17.0),
                ),

              ),
            )
          ],
        ),
        //    shape: RoundedRectangleBorder(
        //         side: new BorderSide(color: Theme.of(context).primaryColor, width: 2.0)),
      ),
    );
  }


}