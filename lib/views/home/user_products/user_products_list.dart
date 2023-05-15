import 'package:flutter/material.dart';
import 'package:shopping_cart/models/product.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/services/database_service.dart';
import 'package:shopping_cart/views/home/user_products/user_product_item.dart';

import 'add_user_product.dart';

class UserProductList extends StatelessWidget {

  final Profile profile;

  UserProductList({this.profile});

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        StreamBuilder(
          stream: ProductDatabase().uploadedProducts(profile.uid),
          builder: (futureContext, AsyncSnapshot<List<Product>> snapshot) {
            print(snapshot.data);
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (buildContext, index) {
                  return UserProductItem(product: snapshot.data[index]);
                },
              );
            } else {
              return Container();
            }
          }
        ),
        Positioned(
          bottom: 25,
          right: 25,
          child: FloatingActionButton(
            backgroundColor: Colors.amber,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AddUserProduct(profile: profile);
                  }
              ));
            },
          ),
        )
      ],
    );
  }
}