import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/CartProvider.dart';
import '../Services/firestoreDb.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final dbHelper = DBhelper();
  double? price;
  int? Qty;
  List<double> totPrice=[];
  final cart = cartProvider();
  double sum = 0.0;
  int quntity=0;
  double newprice=0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        StreamBuilder(
            stream:FirebaseFirestore.instance.collection('productcart').snapshots(),
            builder: (context,  snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                    child: ListView.builder(
                        itemCount:snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          // totPrice.add(double.parse(ds['item_price'].toString()));

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image(
                                          height: 100,
                                          width: 100,
                                          image: NetworkImage(
                                            ds['item_image_url'].toString(),
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  ds['product_name'].toString()
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                 'Rs '+ds['item_price'].toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                     String Pname=ds['product_name'].toString();
                                                     double price=double.parse(ds['item_price'].toString());
                                                     deleteItem(Pname,price);
                                                    },
                                                    child: Icon(Icons.delete)),

                                              ],
                                            ),
                                            SizedBox(height:25 ,),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 45,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius
                                                    .circular(5)
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children:  [
                                                  InkWell(
                                                      onTap:(){
                                                        quntity--;
                                                        newprice=quntity+ double.parse(ds['item_price'].toString()) ;
                                                        cart.removeotalprice(newprice);
                                                      },

                                                      child: Icon(Icons.remove)),
                                                  Text("1"),
                                                  InkWell(
                                                      onTap:(){
                                                        quntity++;
                                                        newprice=quntity+ double.parse(ds['item_price'].toString()) ;
                                                        cart.addtotalprice(newprice);
                                                      },
                                                      child: Icon(
                                                          Icons.add)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );

                        }));
              }
              return Text('');
            }),
        Consumer<cartProvider>(
          builder: (context, value, child) {
            return Visibility(
              visible:value.getTotalprice().toStringAsFixed(2) == "0.00"
                  ? false
                  : true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableWidget(

                      title: 'Sub Total',
                      value:value.getTotalprice().toStringAsFixed(2))
                ],
              ),
            );
          },
        ),
      ]),
    );
  }

  Future<void> deleteItem(String pname,double price) async {

    FirebaseFirestore.instance
        .collection("productcart")
        .where("product_name", isEqualTo : pname)
        .get().then((value){
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection("productcart").doc(element.id).delete().then((value){
          print("Success!");
        });
      });
    }).then((value) {
      cart.removeotalprice(price);
    },);

  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;

  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            style: Theme
                .of(context)
                .textTheme
                .subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme
                .of(context)
                .textTheme
                .subtitle2,
          )
        ],
      ),
    );
  }
}
