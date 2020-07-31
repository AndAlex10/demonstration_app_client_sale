import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: controller.page == page ?
                WidgetsCommons.buttonColor() :  Colors.black87,

              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 18.0,
                    color: controller.page.round() == page ?
                    WidgetsCommons.buttonColor() :  Colors.black87, fontWeight: controller.page.round() == page ? FontWeight.w900 : FontWeight.normal),
              )
            ],
          ),
        ),
      ),
    );
  }
}