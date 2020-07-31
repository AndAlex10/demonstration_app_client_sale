import 'package:mobx/mobx.dart';
import 'package:venda_mais_client_buy/models/entities/cart.entities.dart';
import 'package:venda_mais_client_buy/models/entities/coupon.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payment.order.entities.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';

part 'cart.store.g.dart';

class CartStore = _CartStore with _$CartStore;
abstract class _CartStore with Store {
  @observable
  EstablishmentData establishment;
  @observable
  PaymentOrder payment;
  @observable
  Coupon coupon;
  @observable
  bool isLoading = false;
  @observable
  double change = 0.00;
  @observable
  double shipPrice;
  @observable
  int distance;

  @observable
  ObservableList<CartProduct> _cartContent = ObservableList<CartProduct>();
  ObservableList<CartProduct> get cartContent => _cartContent;

  @computed
  List<CartProduct> get uniqueProducts => ObservableList.of(_cartContent).toSet().toList();

  @observable
  ProductData productCurrent;

  @observable
  int quantity = 1;

  @observable
  double amountProduct = 0.00;

  @action
  void setEstablishment(EstablishmentData establishmentData){
    this.establishment = establishmentData;
  }

  @action
  void setPayment(PaymentOrder paymentOrder){
    this.payment = paymentOrder;
  }

  @action
  void setCoupon(Coupon coupon){
    this.coupon = coupon;
  }

  @action
  void setLoading(bool loading){
    this.isLoading = loading;
  }

  @action
  void setChange(double change){
    this.change = change;
  }

  @action
  void setShipPrice(double shipPrice){
    this.shipPrice = shipPrice;
  }

  @action
  void setDistance(int distance){
    this.distance = distance;
  }

  @action
  void addProduct(CartProduct cartProduct){
    _cartContent.add(cartProduct);
  }

  @action
  void clearCart(){
    _cartContent.clear();
  }

  @action
  void removeItem(CartProduct value){
    _cartContent.remove(value);
  }

  @action
  void setProduct(ProductData productData){
    quantity = 1;
    amountProduct = productData.price;
    this.productCurrent = productData;

  }

  void checkOption(int hash){
    this.productCurrent.checkOption(hash);
  }

  @action
  void setItemSub(){
    quantity -=1;
  }

  @action
  void setItemAdd(){
    quantity +=1;
  }

  @action
  void setAmountProduct(double value){
    amountProduct = value * quantity;
  }



}