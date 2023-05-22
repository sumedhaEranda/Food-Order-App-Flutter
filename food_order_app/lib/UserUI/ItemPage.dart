import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'PlaceOrderScreen.dart';

class ItemPage extends StatelessWidget {

const ItemPage({
super.key,
required this.items,
});

final String items;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where('item_image_url', isEqualTo:items)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              String itemname = ds["product_name"].toString();
              double itemprice =
              double.parse(ds["item_price"].toString());
              int quantity = int.parse(ds["quantity"].toString());
              String image = ds["item_image_url"].toString();

              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height / 1.7,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              items,
                            ),
                          )),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                  Color.fromARGB(224, 225, 225, 255),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 22,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RatingBar.builder(
                                  initialRating: 4,
                                  minRating: 1,
                                  maxRating: 5,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemSize: 18,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.red,
                                  ),
                                  onRatingUpdate: (index) {}),
                            ],
                          ),
                          Text(
                            'USD ${ds['item_price']}',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.withOpacity(0.7),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 20, right: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ds['product_name'].toString(),
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(
                            width: 90,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(CupertinoIcons.minus,color: Colors.white,size: 20,),
                                Icon(CupertinoIcons.plus,color: Colors.white,size: 20,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // height should be fixed for vertical scrolling
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                        // adding borders around the widget
                        border: Border.all(
                          color: Colors.white,
                          width: 5,

                        ),
                      ),
                      child: SingleChildScrollView(
                        // for Vertical scrolling
                        scrollDirection: Axis.vertical,
                        child: Text(
                          ds['description'].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily:"Noto Sans CJK SC",
                            fontSize: 15.0,
                            letterSpacing: 3,
                            wordSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            insertTotheCart(itemname, itemprice, image);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 70),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              CupertinoIcons.cart_fill,
                              size: 22,
                              color: Color(0xFFFD725A),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceOrderScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 70),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text("Buy Now"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
              : const Text("data");
        },
      ),
    );




  }

  Future<bool> insertTotheCart(
      String itemName, double itemPrice, String image) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('productcart')
        .where('product_name', isEqualTo: itemName)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      await FirebaseFirestore.instance.collection('productcart').add(
        {
          'product_name': itemName,
          'item_image_url': image,
          'item_price': itemPrice,
        },
      );
      return true;
    } else {
      return false;
    }
  }
}


