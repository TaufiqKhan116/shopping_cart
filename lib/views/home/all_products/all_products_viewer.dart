import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/models/product.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/providers/home_notifiers.dart';
import 'package:shopping_cart/services/database_service.dart';
import 'package:shopping_cart/views/home/all_products/favourite_products_viewer.dart';
import 'package:shopping_cart/views/home/all_products/search_dialog.dart';
import 'package:shopping_cart/views/home/all_products/select_catagory_dialog.dart';
import 'package:shopping_cart/views/home/all_products/shopping_item.dart';

class AllProductViewer extends StatelessWidget {

  final Profile currentProfile;

  AllProductViewer({this.currentProfile});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryChangeNotifier()),
        ChangeNotifierProvider(create: (_) => SearchParameterChangeNotifier()),
      ],
      builder: (providerContext, widget) {
        return Stack(children: [
          Column(children: [
            Expanded(
              child: StreamBuilder(
                stream: ProductDatabase().getProducts(category: providerContext.watch<CategoryChangeNotifier>().category, searchParam: providerContext.watch<SearchParameterChangeNotifier>().searchParam),
                builder: (buildContext, AsyncSnapshot<List<Product>> snapshot) {
                  return ListView.builder(
                      itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
                      itemBuilder: (buildContext, index) {
                        return ShoppingItem(product: snapshot.data[index], currentProfile: currentProfile);
                      });
                },
              ),
            ),
          ]),
          Positioned(
            right: 10,
            top: 0,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FavouriteProductsViewer(currentProfile: currentProfile);
                        }
                    ));
                  },
                  icon: Icon(Icons.shopping_cart_outlined),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (context) {
                          return SearchDialog(callBack: (val) {
                            providerContext.read<SearchParameterChangeNotifier>().set(val);
                          });
                        });
                  },
                  icon: Icon(Icons.search),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (context) {
                          return SelectCategoryDialog(callBack: (val) {
                            providerContext.read<SearchParameterChangeNotifier>().set('');
                            providerContext.read<CategoryChangeNotifier>().set(val);
                          });
                        });
                  },
                  icon: Icon(Icons.menu),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ]);
      }
    );
  }
}
