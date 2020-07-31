import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:venda_mais_client_buy/controllers/address.controller.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:venda_mais_client_buy/views/address/address.list.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class MapsView extends StatefulWidget {
  final PlacesDetailsResponse place;
  final String number;
  MapsView(this.place, this.number);

  @override
  _MapsViewState createState() => _MapsViewState(this.place, this.number);
}

class _MapsViewState extends State<MapsView> {
  final PlacesDetailsResponse place;
  final String number;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Set<Marker> _markers = {};
  final _controllerAddress = AddressController();
  var _center = LatLng(0.0, 0.0);
  Completer<GoogleMapController> _controller = Completer();

  _MapsViewState(this.place, this.number) {
    _center = LatLng(place.result.geometry.location.lat, place.result.geometry.location.lng);
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
    _checkLocation();
  }

  void _checkLocation() {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(_center.toString()),
        position: _center,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _checkLocation();
  }

  @override
  Widget build(BuildContext context) {
    var userStore = Provider.of<UserStore>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Column(children: <Widget>[
          Text("${place.result.name}, $number", style: TextStyle(fontSize: 17.0), maxLines: 1, overflow: TextOverflow.ellipsis,),
          Text(place.result.vicinity, style: TextStyle(fontSize: 14.0, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis,)
        ],),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 18.0,
            ),
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  heroTag: 'btn2',
                  onPressed: () async{
                    await _refreshAddress(userStore, place);
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: WidgetsCommons.buttonColor(),
                  child: const Icon(Icons.add, size: 36.0),
                ),),
          ),
        ],
      ),
    );
  }

  Future<Null> _refreshAddress(UserStore userStore, PlacesDetailsResponse detail) async {
    await _controllerAddress.add(userStore, detail, _center.latitude,_center.longitude, number).then((result){
      if(result.success) {
        _onSuccess();
      } else {
        WidgetsCommons.onFail(_scaffoldKey, result.message);
      }
    });
  }

  void _onSuccess() {
    WidgetsCommons.onSucess(_scaffoldKey, 'Endereço Adicionado!');
    Future.delayed(Duration(seconds: 1)).then((_) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => AddressListView(ModuleEnum.ADDRESS)));
    });
  }
}
