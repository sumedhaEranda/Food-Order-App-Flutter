import 'dart:convert';
import 'dart:io' ;
import 'dart:io' as Io ;
import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../UserUI/Cart.dart';
import '../UserUI/Orders.dart';
import '../UserUI/Profile.dart';
import '../UserUI/PurchersOrder.dart';
import '../UserUI/home.dart';
import '../UserUI/setting.dart';
import 'Model/CartModel.dart';
import 'NavBar.dart';

class MyHome extends StatefulWidget {
  final String items;
  final String url;
  final String username;

  const MyHome({
    required this.items,
    required this.url,
    required this.username,
  });

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final _pages = [home(), MyPurchersOrder(),CartPage(),Orders(), Profile()];
  final _pageController = PageController();
  late String email;
  List<Text> messageWidgets = [];
  File? imagefile,newloadimage;
  String myId = '';
  String myUsername = '';
  String myUrlAvatar = '';
  String newurl = '';
  List<String> Listproductitem = [];
  String? inputText = "";
  @override
  Widget build(BuildContext context) {
    myId = widget.items;
    myUrlAvatar=widget.url;
    myUsername=widget.username;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,

      ),
      drawer: Drawer(

        child: ListView(

          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                myUsername,
              ),
              accountEmail: Text(
                myId,
              ),
              currentAccountPicture: InkWell(
                onTap: () {
                  getupdateImage();
                },
                child:ClipOval(
                  child: Image.memory(
                    base64Decode(myUrlAvatar),
                    fit: BoxFit.cover,
                  ),

                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg',)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Friends'),
              onTap: () => null,
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () => null,
            ),
            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Request'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const setting()),
                ),
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Policies'),
              onTap: () => null,
            ),
            const Divider(),
            ListTile(
              title: const Text('Exit'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () => null,
            ),
            const Divider(
              color: Colors.black,height: 4,
            ),
          ],
        ),
      ),
      body:PageView(
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              controller: _pageController,
              children: _pages,

            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ('home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank), label: ('Food')),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_travel), label: ('Cart')),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu), label: ('Orders')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: ('Profile')),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(_selectedIndex,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        },
      ),

    );

  }



  Future getupdateImage() async {
    // FirebaseFirestore firestore=FirebaseFirestore.instance;
     final picker = ImagePicker();
     final pickedFile = await picker.getImage(source: ImageSource.gallery);
     if(pickedFile!=null){

       myUrlAvatar.replaceAll(new RegExp(r'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/default_images%2F'), '').split('?')[0];

       FirebaseStorage.instance.ref().child(myUrlAvatar).delete().then((_) => print('Successfully deleted $myUrlAvatar storage item' ));
       // Delete the file
       final ref = FirebaseStorage.instance
           .ref()
           .child('user Images')
           .child('${DateTime.now()}.jpg');
       await ref.putFile(imagefile!);
       newurl = await ref.getDownloadURL();

       var collection = FirebaseFirestore.instance.collection('users');
       collection
           .doc(email)
           .update({'item_image_url' : newurl}) // <-- Updated data
           .then((_) => print('Success'))
           .catchError((error) => print('Failed: $error'));
     }
    //
    // setState(() {
    //   imagefile = File(pickedFile!.path);
    // });
    //
    // document.reference.updateData(<String, dynamic>{
    //
    //   name: this.name
    // });
    // var snapshots = firestore.collection('posts').document(email).get();
    //
    // await snapshots.forEach((document) async {
    //   document.reference.updateData(<String, dynamic>{
    //     name: this.name
    //   });
    // })
  }
}

