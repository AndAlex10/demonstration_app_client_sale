import 'package:connectivity/connectivity.dart';

class ConnectComponent{

  Future<bool> checkConnect() async{
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
      return true;
    } else {
      print("Unable to connect. Please Check Internet Connection");
      return false;
    }
  }

}