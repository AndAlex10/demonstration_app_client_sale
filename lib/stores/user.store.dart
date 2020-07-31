import 'package:dart_amqp/dart_amqp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobx/mobx.dart';
import 'package:venda_mais_client_buy/config/rabbitmq.config.dart';
import 'package:venda_mais_client_buy/controllers/user.controller.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';

part 'user.store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  @observable
  FirebaseMessaging fbMessaging = new FirebaseMessaging();
  @observable
  UserEntity user;
  @observable
  String addressDefaultName;
  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @observable
  var category = "";

  Client connectionRabbitMQ;

  _UserStore() {
    loadUser();
    configRabbitMQ();
  }

  @action
  setUser(UserEntity userEntity) {
    this.user = userEntity;
  }

  @action
  setLoading(bool loading) {
    this._isLoading = loading;
  }

  bool isLoggedIn() {
    return user != null;
  }

  bool isNotAddress() {
    return user.addressDefault == null;
  }

  @action
  setAddressDefault(String address) {
    addressDefaultName = address;
  }

  @action
  setCategory(String id) {
    if (id == this.category) {
      this.category = "";
    } else {
      this.category = id;
    }
    print((this.category));
  }

  Future<Null> loadUser() async {
    UserController userController = new UserController();
    if (this.user == null) {
      this.user = await userController.load();
      if (this.user != null) {
        addressDefaultName =
            userController.getTitleAddressDefault(user.addressList);
        _configureFirebaseListeners();
      }
    }
  }

  Future<bool> getUser() async {
    UserController userController = new UserController();
    if (this.user == null && !this._isLoading) {
      this._isLoading = true;
      this.user = await userController.load();
      if (this.user != null) {
        addressDefaultName =
            userController.getTitleAddressDefault(user.addressList);
        _configureFirebaseListeners();
      }
      this._isLoading = false;
    }

    return this._isLoading;
  }

  _configureFirebaseListeners() {
    fbMessaging.subscribeToTopic(user.id);
    fbMessaging.subscribeToTopic("???");

    fbMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

  Future<void> configRabbitMQ() async{
    RabbitMQConfig rabbitMQConfig = new RabbitMQConfig();
    try {
      ConnectionSettings settingsRabbitMQ = await rabbitMQConfig.connect();
      connectionRabbitMQ = new Client(settings: settingsRabbitMQ);
    } on ConnectionFailedException catch(e){
      print(e.message);
    } catch(e){
      print(e.toString());
    }
  }
}
