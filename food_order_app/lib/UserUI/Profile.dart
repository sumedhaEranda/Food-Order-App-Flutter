import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../UI/MainHome.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  //edit controller
  final TextEditingController ProductNameController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController PriceController = TextEditingController();
  final TextEditingController QuantityController = TextEditingController();
  String errorMessage = '';
  File? imagefile, defulfile;
  String? image_Url;
  double? price;
  int? Qty;
  //firebase
  final AuthResult = FirebaseAuth.instance;
  late UserCredential userCred;

  @override
  Widget build(BuildContext context) {
    final ProductNameField = TextFormField(
      autofocus: false,
      controller: ProductNameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.add),
          fillColor: Colors.white,
          filled: true,
          hintText: 'ProductName',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter product Name");
        }
      },
      onSaved: (value) {
        ProductNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final PriceField = TextFormField(
      autofocus: false,
      controller: PriceController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.add),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Price',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Provide item Price");
        }
      },
      onSaved: (value) {
        PriceController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final DescriptionField = TextFormField(
      autofocus: false,
      controller: DescriptionController,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.description),
          fillColor: Colors.white,
          hintMaxLines: 6,
          filled: true,
          hintText: 'Description',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Provide Description");
        }
      },
      onSaved: (value) {
        DescriptionController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final QuantityField = TextFormField(
      autofocus: false,
      controller: QuantityController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.production_quantity_limits),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Qty',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Provide Quantity");
        }
      },
      onSaved: (value) {
        QuantityController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 35),
            child: const Text(
              'Add Product',
              style: TextStyle(color: Colors.black87, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 5,
                left: 5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getImage();
                    },
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage: imagefile == null
                          ? const AssetImage('assets/user.png')
                          : Image.file(imagefile!).image,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProductNameField,
                  const SizedBox(
                    height: 20,
                  ),
                  DescriptionField,
                  const SizedBox(
                    height: 20,
                  ),
                  PriceField,
                  const SizedBox(
                    height: 20,
                  ),
                  QuantityField,
                  const SizedBox(
                    height: 40,
                  ),
                  (errorMessage != ''
                      ? Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        )
                      : Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ADD ',
                        style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: IconButton(
                            color: Colors.black,
                            iconSize: 40,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              signUp();
                            }),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    File compressedFile = await FlutterNativeImage.compressImage(pickedFile!.path,quality: 100,percentage: 75);

    setState(() {
      imagefile = compressedFile;
    });
  }

  void signUp() async {
    setState(() {
      errorMessage = '';
    });

    if (_formKey.currentState!.validate()) {
      try {
        try {
          // Save username name
          final ref = FirebaseStorage.instance
              .ref()
              .child('Product_item_Images')
              .child('${DateTime.now()}.jpg');

          await ref.putFile(imagefile!);
          image_Url = await ref.getDownloadURL();
          price=double.parse(PriceController.text);
          Qty=int.parse(QuantityController.text);
          await FirebaseFirestore.instance
              .collection('products')
              .add(
            {
              'product_name': ProductNameController.text,
              'item_image_url': image_Url,
              'description': DescriptionController.text,
              'item_price': price,
              'quantity': Qty,
            },
          );
        } catch (e) {
          handleError();
        }
        Fluttertoast.showToast(
            msg: "${ProductNameController.text}:Item Successfully");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyHome(items: '',url: '',username: '',)));
      } catch (e) {
        e.toString();
        Fluttertoast.showToast(msg: "Email Id already Exist!!!");
      }
    }
  }

  void handleError() {
    setState(() {
      errorMessage = 'Email Id already Exist!!!';
    });
  }
}
