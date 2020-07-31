import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';

class ConnectFail extends StatelessWidget {
  final VoidCallback execute;

  ConnectFail(this.execute);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.0,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Encontramos um problema na sua conexão",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
              child: Text(
            "Por favor, verifique sua conexão com a internet e tente novamente",
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400, color: Colors.black45),
                textAlign: TextAlign.center,
          )),
          SizedBox(
            height: 12.0,
          ),
          FlatButton(
              onPressed: () {
                execute();
              },
              child: Text(
                "Tente Novamente",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: WidgetsCommons.buttonColor()),
              ))
        ],
      ),
    );
  }
}
