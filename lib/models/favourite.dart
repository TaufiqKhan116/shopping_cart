import 'package:uuid/uuid.dart';

class FavouritePair {
  String pairId = Uuid().v1();
  String profileId;
  String productId;

  FavouritePair({this.profileId, this.productId});
}