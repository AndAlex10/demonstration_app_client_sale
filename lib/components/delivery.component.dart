import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/fee.delivery.entities.dart';
import 'package:venda_mais_client_buy/repositories/fee.delivery.repository.dart';
import 'package:venda_mais_client_buy/repositories/fee.delivery.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/maps.repository.dart';
import 'package:venda_mais_client_buy/repositories/maps.repository.intefarce.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';

class DeliveryComponent {

  IDeliveryRepository repository;
  IMapsRepository mapsRepository;
  ConnectComponent connect;

  DeliveryComponent(){
    repository = new DeliveryRepository();
    mapsRepository = new MapsRepository();
    connect = new ConnectComponent();
  }

  DeliveryComponent.tests(this.repository, this.mapsRepository, this.connect);

  Future<double> calculateFee(Address address, CartStore cartStore) async{
    double value;
    if(await connect.checkConnect()) {
      int distance = await mapsRepository.getMapDistance("${cartStore.establishment.latitude},${cartStore.establishment.longitude}",
          "${address.latitude},${address.longitude}");
      List<FeeDelivery> fees = await repository.getAll(
          cartStore.establishment.id);

      if (distance != null) {
        for (var h = 0; h < fees.length; h++) {
          if (double.parse(distance.toString()) >= fees[h].min &&
              double.parse(distance.toString()) <= fees[h].max) {
            value = fees[h].value;
          }
        }
      }

      cartStore.setShipPrice(value);
      if (cartStore.shipPrice != null) {
        cartStore.setDistance(distance);
      }
    }

    return value;
  }

  Future<double> getCommissionDelivery(int distance) async{
    return await repository.getCommissionDelivery(distance);
  }

}