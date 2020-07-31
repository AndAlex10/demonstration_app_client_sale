import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:venda_mais_client_buy/components/maps.component.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:venda_mais_client_buy/views/address/address.list.view.dart';
import 'package:venda_mais_client_buy/views/address/maps.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AddressTabView extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => AddressListView(ModuleEnum.ADDRESS)));

          return Future.value(false);
        },
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('Localizar Endereço'),
              centerTitle: true,
            ),
            body: Observer(builder: (_) {
                if (store.isLoading){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: SizedBox(
                              height: 50.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black12)),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.search),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "Digite o endereço",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                textColor: Colors.black38,
                                color: Colors.white,
                                onPressed: () async {
                                  await _handlePressButton(context);
                                },
                              ),
                            )),
                      ],
                    ),
                  );
                }
              },
            )));
  }

  Future<void> _handlePressButton(BuildContext context) async {
    MapsComponent _mapsController = new MapsComponent();
    await _mapsController.getKeyMap();

    List<String> list = [];
    list.add("establishment");
    list.add("address");
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: _mapsController.key,
      onError: onError,
      language: "pt",
     // types: ["(regions)"],
      components: [Component(Component.country, "br")],

    );

    PlacesDetailsResponse response = await _mapsController.getPlaceDetail(p);
    if (response.result != null) {
      if(!_mapsController.validateAddress(response)){
        _infoAddressInvalid(context);
      } else {
        for (var i = 0; i < response.result.addressComponents.length; i++) {
          AddressComponent addressComponent =
          response.result.addressComponents[i];
          for (var h = 0; h < addressComponent.types.length; h++) {
            if (addressComponent.types[h] == 'street_number')
              _numberController.text = addressComponent.longName;
          }
        }

        if (_numberController.text == "") {
          await _displayDialog(context, _numberController);
        }
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MapsView(response, _numberController.text)));
      }
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  _displayDialog(BuildContext context, TextEditingController controller) async {
    return Alert(
      context: context,
      // type: AlertType.info,
      title: 'Quer informar o número?',
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(hintText: "Informe aqui o número"),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: WidgetsCommons.buttonColor(),
          onPressed: () {
            controller.text = "";
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            "Confirmar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: WidgetsCommons.buttonColor(),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }


  _infoAddressInvalid(BuildContext context) async {
    return Alert(
      context: context,
      // type: AlertType.info,
      title: "Favor selecionar um endereço mais especifico",
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
}
