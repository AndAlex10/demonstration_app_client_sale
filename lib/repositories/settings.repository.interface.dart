import 'package:venda_mais_client_buy/models/entities/settings.entity.dart';

abstract class ISettingsRepository {

  Future<SettingsData> getManagerServer();
}