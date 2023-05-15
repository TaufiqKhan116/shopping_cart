import 'package:uuid/uuid.dart';

class Product {
  String productId = Uuid().v1();

  String ownerId;
  String productImageUrl = '';
  String productName;
  String productCategory;
  String productPrice;

  Product({ this.ownerId, this.productImageUrl, this.productName, this.productCategory, this.productPrice });
}