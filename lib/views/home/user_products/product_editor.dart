import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/constants/loading.dart';
import 'package:shopping_cart/constants/shared_constants.dart';
import 'package:shopping_cart/models/product.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/providers/authentication_notifiers.dart';
import 'package:shopping_cart/services/database_service.dart';
import 'package:shopping_cart/services/storage_service.dart';

class ProductEditor extends StatelessWidget {
  final Product product;
  final imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();

  String _category = '';

  ProductEditor({this.product});

  Future getImage(ImageSource imageSource) async {
    final pickerFile = await imagePicker.getImage(source: imageSource);
    if (pickerFile != null) {
      return File(pickerFile.path);
    } else {
      return null;
    }
  }

  void setControllers() {
    productNameController.text = product.productName;
    productPriceController.text = product.productPrice;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageFileNotifier()),
          ChangeNotifierProvider(create: (_) => LoadingStateNotifier())
        ],
        builder: (providerContext, widget) {

          setControllers();

          return (providerContext.watch<LoadingStateNotifier>().loadingNeeded)? Loading() : Scaffold(
              appBar: AppBar(
                title: Text('Upload product'),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          shadowColor: Colors.amber[400],
                          child: Stack(
                            children: [
                              Consumer<ImageFileNotifier>(
                                  builder: (_, imageFileNotifier, widget) {
                                    File imageFile = imageFileNotifier.imageFile;
                                    return (imageFile != null) ? Image(
                                        image: FileImage(imageFile),
                                        width: 300,
                                        height: 200,
                                        fit: BoxFit.cover
                                    ) : Image(
                                        image: NetworkImage(product.productImageUrl),
                                        width: 300,
                                        height: 200,
                                        fit: BoxFit.cover
                                    );
                                  }
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    return showDialog<void>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Upload Image from'),
                                            actions: [
                                              FlatButton(
                                                child: Text('Camera'),
                                                onPressed: () async {
                                                  File imageFile = await getImage(
                                                      ImageSource.camera);
                                                  providerContext.read<ImageFileNotifier>().changeImageFile(imageFile);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Gallery'),
                                                onPressed: () async {
                                                  File imageFile = await getImage(
                                                      ImageSource.gallery);
                                                  providerContext.read<ImageFileNotifier>().changeImageFile(imageFile);
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  shape: StadiumBorder(),
                                  child: Icon(Icons.camera_alt_rounded),
                                  fillColor: Colors.amber,
                                  splashColor: Colors.deepOrange,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: productNameController,
                          decoration: InputDecoration(
                              labelText: 'Product name',
                              icon: Icon(Icons.title)
                          ),
                          validator: (val) {
                            String errorMsg;
                            if(val.isEmpty)
                              errorMsg = "Field can't be empty";

                            return errorMsg;
                          },
                        ),
                        SizedBox(height: 5),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: 'Product category',
                              icon: Icon(Icons.list)
                          ),
                          items: categoryList.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text('$item'),
                            );
                          }).toList(),
                          onChanged: (val) {
                            _category = val;
                            print(_category);
                          },
                          validator: (val) {
                            String errorMsg;
                            if(val == null)
                              errorMsg =  'Must select a category';
                            return errorMsg;
                          },
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: productPriceController,
                          decoration: InputDecoration(
                              labelText: 'Product price',
                              suffix: Text('bdt'),
                              icon: Icon(Icons.attach_money)
                          ),
                          validator: (val) {
                            String errorMsg;
                            if(val.isEmpty)
                              errorMsg = "Field can't be empty";
                            return errorMsg;
                          },
                        ),
                        SizedBox(height: 5),
                        Consumer<ImageFileNotifier>(
                            builder: (_, imageFileNotifier, widget) {
                              return RaisedButton(
                                child: Text('Update product'),
                                color: Colors.blue[200],
                                splashColor: Colors.blue,
                                onPressed: () async {

                                  String imageUrl = product.productImageUrl;

                                  if(imageFileNotifier.imageFile != null) {
                                    await ProductImageStorage().deleteProductImage(product.productId);
                                    StorageTaskSnapshot imageUploadResult = await ProductImageStorage().uploadProductImage(product.productId, imageFileNotifier.imageFile);
                                    imageUrl = await imageUploadResult.ref.getDownloadURL();
                                  }

                                  if(_formKey.currentState.validate()) {

                                    providerContext.read<LoadingStateNotifier>().set(true);
                                    dynamic result = await ProductDatabase(productId: product.productId).updateProductData(product.productId, product.ownerId, imageUrl, productNameController.text, _category, productPriceController.text);
                                    Navigator.pop(context);
                                  }

                                },
                              );
                            }
                        )
                      ],
                    ),
                  ),
                ),
              )
          );
        }
    );
  }
}
