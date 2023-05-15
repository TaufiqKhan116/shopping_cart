import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shopping_cart/constants/avatar.dart';
import 'package:shopping_cart/constants/fetching.dart';
import 'package:shopping_cart/constants/loading.dart';
import 'package:shopping_cart/constants/updating.dart';
import 'package:shopping_cart/models/favourite.dart';
import 'package:shopping_cart/models/product.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/services/database_service.dart';
import 'package:shopping_cart/views/home/user_products/seller_profile_viewer.dart';
import 'package:shopping_cart/views/image_viewer_dialog.dart';

// ignore: must_be_immutable
class ShoppingItem extends StatelessWidget {
  final Product product;
  final Profile currentProfile;

  Profile _profile;

  ShoppingItem({ this.product, this.currentProfile });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.amber[400],
      child: Stack(
        children: [
          GestureDetector(
            child: Image(
              image: NetworkImage(product.productImageUrl),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (_, widget, imageChunkEvent) {
                if(imageChunkEvent == null) return widget;
                return Container(
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: Fetching(),
                  )
                );
              },
            ),
            onTap: () {
              showDialog<void>(
                context: context,
                child: ImageViewerDialog(imgUrl: product.productImageUrl)
              );
            },
          ),
          Positioned(
            bottom: 22,
            left: 0,
            child: Text(
              '${product.productName}',
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 23,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 0,
            child: Text(
              '${product.productPrice} Bdt',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          StreamBuilder(
            stream: ProfileDatabase(uid: product.ownerId).userData,
            builder: (buildContext, AsyncSnapshot<Profile> snapshot) {

              if(snapshot.hasData) {
                _profile = snapshot.data;
              }

              return Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber[600],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showDialog<void>(
                            context: context,
                            child: ImageViewerDialog(imgUrl: snapshot.data.imageUrl)
                        );
                      },
                      child: Avatar(
                        imageProvider: (snapshot.hasData) ? NetworkImage(snapshot.data.imageUrl) : AssetImage('assets/images/empty_profile_pic.png'),
                        radius: 25,
                      ),
                    ),
                  ));
            }
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              children: [
                StreamBuilder(
                  stream: FavouriteDatabase().doesDocumentExist(currentProfile.uid, product.productId),
                  builder: (context, AsyncSnapshot<List<FavouritePair>> snapshot) {
                    return RaisedButton(
                      onPressed: () {
                        if(snapshot.data.length == 0) {
                          FavouritePair favouritePair = FavouritePair(profileId: currentProfile.uid, productId: product.productId);
                          FavouriteDatabase(pairId: favouritePair.pairId).updateFavourite(favouritePair.profileId, favouritePair.productId);
                        }
                      },
                      child: const Icon(Icons.add_shopping_cart),
                      shape: const StadiumBorder(),
                      color: Colors.amber,
                      splashColor: Colors.deepOrange,
                    );
                  }
                ),
                SizedBox(width: 5),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SellerProfileViewer(profile: _profile);
                        }
                    ));
                  },
                  child: const Icon(Icons.shopping_bag),
                  shape: const StadiumBorder(),
                  color: Colors.amber,
                  splashColor: Colors.deepOrange,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
