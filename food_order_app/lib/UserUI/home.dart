import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Controller/CartProvider.dart';
import '../Services/firestoreDb.dart';
import 'ItemPage.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController controller = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  DBhelper _bhelper = DBhelper();
  List<Map<String, dynamic>> data = [];
  late double price = 0.0;
  late int Qty = 0;
  late String name;
  String? inputText = "";
  final cart = cartProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextField(
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          hintText: 'Search',
                          hintStyle:
                          TextStyle(color: Colors.grey, fontSize: 18),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.search_rounded),
                            width: 18,
                          )),
                      onChanged: (val) {
                        setState(() {
                          inputText = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .where("product_name",
                        isGreaterThanOrEqualTo: inputText)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("Loading"),
                        );
                      }

                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =document.data() as Map<String, dynamic>;
                          return Card(

                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          String url=data["item_image_url"].toString();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ItemPage(items:url)));
                                        },
                                        child: Image(
                                            height: 100,
                                            width: 100,
                                            image: NetworkImage(
                                              data["item_image_url"].toString(),
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data["product_name"],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              data["quantity"].toString(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              (  'USD ${data["item_price"]}'),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                height: 35,
                                                width: 100,
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      String Pname =data["product_name"].toString();
                                                      double pprice = double.parse( data["item_price"].toString());
                                                      int quantity = int.parse( data["quantity"].toString());
                                                      String image =data["item_image_url"].toString();
                                                      insertTotheCart( Pname, pprice,quantity,image).whenComplete((() {
                                                        AnimatedSnackBar.rectangle(
                                                            data["product_name"] .toString(),'Added the Cart',
                                                            type: AnimatedSnackBarType.success,
                                                            mobileSnackBarPosition:MobileSnackBarPosition.bottom,
                                                            desktopSnackBarPosition:DesktopSnackBarPosition.topRight).show( context,);
                                                      }));
                                                    },
                                                    icon:
                                                    Icon(Icons.card_travel),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> insertTotheCart(
      String pname, double pprice, int quantity, String image) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('productcart')
        .where('product_name', isEqualTo: pname)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      await FirebaseFirestore.instance.collection('productcart').add(
        {
          'product_name': pname,
          'item_image_url': image,
          'item_price': pprice,
        },
      );
      cart.addtotalprice(pprice);
      return true;
    } else {
      return false;
    }
  }
}
