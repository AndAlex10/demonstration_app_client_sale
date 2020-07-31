
abstract class IMapsRepository {

  Future<String> getKeyMap();

  Future<int> getMapDistance(String origin, String destiny);
}