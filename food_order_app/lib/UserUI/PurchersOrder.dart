import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyPurchersOrder extends StatefulWidget {
  const MyPurchersOrder({Key? key}) : super(key: key);

  @override
  State<MyPurchersOrder> createState() => _MyPurchersOrderState();
}

class _MyPurchersOrderState extends State<MyPurchersOrder> {
  late String price;
  List<String> productitme = [];

  late final String product_name;
  late final String item_image_url;
  late final String item_price;
  late final String description;
  late final String quantity;
  late final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: snapshot.data!.docs.length,
                  padding: EdgeInsets.all(2.0),
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    price = ds["item_price"].toString();

                    return GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              width:
                                  ((MediaQuery.of(context).size.width) / 3) - 100,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        ds["item_image_url"].toString()),
                                    fit: BoxFit.cover),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),

                                   child: Column(
                                           children: [
                                             Text(
                                               ds["product_name"],
                                               style: const TextStyle(
                                                   fontSize: 20,
                                                   fontWeight: FontWeight.w500,
                                                   color: Colors.black12),
                                             ),
                                             Text(
                                               'Rs.$price',
                                               style: const TextStyle(
                                                   fontSize: 20,
                                                   fontWeight: FontWeight.w200,
                                                   color: Colors.black12),
                                             ),
                                           ]
                                   ),

                                   )
                                  ),
                                  ),
                              ), /* add child content here */
                            ),

                    );
                  },
                )
              : const CircularProgressIndicator();
        },
      ),
    );
  }
}
