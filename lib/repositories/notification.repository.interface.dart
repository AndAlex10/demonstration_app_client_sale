
abstract class INotificationRepository {

  Future<Null> create(int orderCode, String idEstablishment);
}