import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/constants/fetching.dart';
import 'package:shopping_cart/constants/updating.dart';
import 'package:shopping_cart/models/product.dart';
import 'package:shopping_cart/providers/authentication_notifiers.dart';
import 'package:shopping_cart/services/database_service.dart';
import 'package:shopping_cart/services/storage_service.dart';
import 'package:shopping_cart/views/home/user_products/product_editor.dart';

import '../../image_viewer_dialog.dart';

class UserProductItem extends StatelessWidget {

  final Product product;

  UserProductItem({ this.product });

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UpdatingProfileNotifier())
      ],
      builder: (providerContext, widget) {
        return (providerContext.watch<UpdatingProfileNotifier>().updating) ? Updating( ) : Card(
          elevation: 5,
          shadowColor: Colors.amber[400],
          child: Stack(
            children: [
              Container(
                child: GestureDetector(
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
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Text(
                  '${product.productName}',
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Positioned(
                top: 24,
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
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  children: [
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ProductEditor(product: product);
                            }
                        ));
                      },
                      child: const Icon(Icons.edit),
                      shape: const StadiumBorder(),
                      color: Colors.amber,
                      splashColor: Colors.deepOrange,
                    ),
                    SizedBox(width: 5),
                    RaisedButton(
                      onPressed: () async {
                        providerContext.read<UpdatingProfileNotifier>().set(true);
                        int result = await ProductDatabase().deleteProduct(product.productId);
                        dynamic deleteResult = await ProductImageStorage().deleteProductImage(product.productId);
                        providerContext.read<UpdatingProfileNotifier>().set(false);
                      },
                      child: const Icon(Icons.delete),
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
    );
  }
}
