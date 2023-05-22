import 'package:flutter/cupertino.dart';


class Cart {
   final String productname;
  final double productprice;
   final int quantity;
   final String image;

  Cart({

    required this.productname,
    required this.productprice,
    required this.quantity,
    required this.image,
  });

  Cart.fromMap(Map<dynamic,dynamic>res)
  :
  productname=res['product_name'],
  productprice=res['item_price'],
  quantity=res['quantity'],
  image=res['item_image_url'];


  Map<String,Object?>toMap(){
    return{
     'product_name' :productname,
      'item_price':productprice,
      'quantity':quantity,
      'item_image_url':image,
    };
  }
}
