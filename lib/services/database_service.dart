import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_cart/models/favourite.dart';
import 'package:shopping_cart/models/product.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/services/storage_service.dart';

class ProfileDatabase {
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('profiles');
  final String uid;

  ProfileDatabase({this.uid});

  Profile _fromDocumentSnapshotToProfile(DocumentSnapshot snapshot) {
    return Profile(
        uid: uid,
        name: snapshot.data()['name'],
        imageUrl: snapshot.data()['imageurl'],
        phoneNumber: snapshot.data()['phonenumber'],
        email: snapshot.data()['email']
    );
  }

  Future updateProfileData(String imageUrl, String name, String phoneNumber, String email) async {
    return await collectionReference.doc(uid).set(
        {
          'imageurl' : imageUrl,
          'name' : name,
          'phonenumber' : phoneNumber,
          'email' : email
        }
    );
  }

  Stream<Profile> get userData {
    return collectionReference.doc(uid).snapshots().map((snapshot) {
      return _fromDocumentSnapshotToProfile(snapshot);
    });
  }

  Future deleteUserData() async {
    try {
      await collectionReference.doc(uid).delete();
      return 0;
    } catch(e) {
      print(e.toString());
      return 1;
    }
  }
}






class ProductDatabase {
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('products');
  final String productId;

  ProductDatabase({ this.productId });

  Product _fromDocumentSnapshotToProduct(DocumentSnapshot snapshot) {
    Product product = Product(
        ownerId: snapshot.data()['ownerid'],
        productImageUrl: snapshot.data()['imageurl'],
        productName: snapshot.data()['productname'],
        productCategory: snapshot.data()['category'],
        productPrice: snapshot.data()['price']
    );
    product.productId = snapshot.data()['productid'];
    return product;
  }

  Future updateProductData(String productId, String ownerId, String imageUrl, String productName, String category, String price) async {

    return await collectionReference.doc(this.productId).set({
      'productid' : productId,
      'ownerid': ownerId,
      'imageurl': imageUrl,
      'productname': productName,
      'category': category,
      'price': price
    });

  }

  Stream<Product> get product {
    return collectionReference.doc(this.productId).snapshots().map((doc) {
      return _fromDocumentSnapshotToProduct(doc);
    });
  }

  Stream<List<Product>> getProducts({String category : 'All', String searchParam : ''}) {
    if(searchParam == '') {
      if (category == 'All') {
        return collectionReference.snapshots().map((snapshot) {
          return snapshot.docs.map((doc) {
            return _fromDocumentSnapshotToProduct(doc);
          }).toList();
        });
      } else {
        return collectionReference.where(
            'category', isEqualTo: category).snapshots().map((snapshot) {
          return snapshot.docs.map((doc) {
            return _fromDocumentSnapshotToProduct(doc);
          }).toList();
        });
      }
    } else {
      return collectionReference.where(
          'productname', isEqualTo: searchParam).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return _fromDocumentSnapshotToProduct(doc);
        }).toList();
      });
    }
  }

  Stream<List<Product>> uploadedProducts(String ownerId) {
    return collectionReference.where('ownerid', isEqualTo: ownerId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return _fromDocumentSnapshotToProduct(doc);
      }).toList();
    });
  }

  Future deleteProduct(String productId) async {
    try {
      await collectionReference.doc(productId).delete();
      return 0;
    } catch(e) {
      print(e.toString());
      return 1;
    }
  }

  void deleteProductsByOwnerId(String ownerId) async {
    QuerySnapshot querySnapshot = await collectionReference.where('ownerid', isEqualTo: ownerId).get();
    querySnapshot.docs.forEach((element) {
      ProductImageStorage().deleteProductImage(element.data()['productid']);
      element.reference.delete();
    });
  }
}






class FavouriteDatabase {
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('favourites');
  final String pairId;

  FavouriteDatabase({this.pairId});

  FavouritePair _fromDocumentSnapshotToFavouritePair(DocumentSnapshot snapshot) {
    FavouritePair favouritePair = FavouritePair(
        profileId: snapshot.data()['profileid'],
        productId: snapshot.data()['productid']
    );
    favouritePair.pairId = snapshot.data()['papairid'];
    return favouritePair;
  }

  Future updateFavourite(String profileId, String productId) async {
    
    return await collectionReference.doc(this.pairId).set({
      'pairid': this.pairId,
      'profileid': profileId,
      'productid': productId,
    });
  }

  Stream<List<FavouritePair>> doesDocumentExist(String profileId, String productId) {
    return collectionReference.where('profileid', isEqualTo: profileId).where('productid', isEqualTo: productId).snapshots().map((event){
      return event.docs.map((e) {
        return _fromDocumentSnapshotToFavouritePair(e);
      }).toList();
    });
  }

  Stream<List<FavouritePair>> getFavourites(String profileId) {
    return collectionReference.where('profileid', isEqualTo: profileId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return _fromDocumentSnapshotToFavouritePair(doc);
      }).toList();
    });
  }

  List<Product> getFavProducts(String profileId) {
    List<Product> productList = List();

    getFavourites(profileId).map((event) {
       event.forEach((favPair) {
        ProductDatabase(productId: favPair.productId).product.map((product) {
          productList.add(product);
        }).toList();
      });
    });
    return productList;
  }

  void deleteFavouritePairByProfileAndProductId(String profileId, String productId) async {
    QuerySnapshot querySnapshot = await collectionReference.where('profileid', isEqualTo: profileId).where('productid', isEqualTo: productId).get();
    querySnapshot.docs.forEach((element) {
      element.reference.delete();
    });
  }

  void deleteFavouritePairByProfileId(String profileId) async {
    QuerySnapshot querySnapshot = await collectionReference.where('profileid', isEqualTo: profileId).get();
    querySnapshot.docs.forEach((element) {
      element.reference.delete();
    });
  }
}