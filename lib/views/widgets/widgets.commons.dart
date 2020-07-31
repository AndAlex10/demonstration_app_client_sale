import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class WidgetsCommons {
  static Widget createTextFormField(String labelText, String textReturn,
      TextEditingController controller, bool valida, bool enabled) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black38),
      ),
      enabled: enabled,
      validator: (text) {
        if (text.isEmpty && valida) return textReturn; else return null;
      },
    );
  }

  static void onSucess(GlobalKey<ScaffoldState> scaffoldKey, String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Color.fromARGB(255, 0, 205, 102),
      duration: Duration(seconds: 2),
    ));
  }

  static void onFail(GlobalKey<ScaffoldState> scaffoldKey, String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }

  static void onGeneric(GlobalKey<ScaffoldState> scaffoldKey, String text, Color color) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    ));
  }

  static Color buttonColor() {
    return Color.fromARGB(255, 251, 116, 2);
  }

  static Color labelColor() {
    return Color.fromARGB(255, 128, 0, 0);
  }


  static Widget optionTileButton(
      BuildContext context, String title, Widget widget, Icon icon) {
    return Card(
        child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: icon,
                      color: Colors.black45,
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => widget));
                      },
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],),

                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 20.0),
                  color: WidgetsCommons.buttonColor(),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => widget));
                  },
                ),
              ],
            )));
  }


  static message(BuildContext context, message, bool erro) async {
    return Alert(
      context: context,
      type: erro ? AlertType.error : AlertType.success,
      title: message,
      buttons: [
        DialogButton(
          child: Text(
            "Fechar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: WidgetsCommons.buttonColor(),
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }

  static Widget noPhoto(){
    return ClipOval(
      child: Image.asset(
        'images/peopleicon.jpg',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }
}
