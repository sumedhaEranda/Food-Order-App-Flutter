import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../UserUI/PurchersOrder.dart';
import '../UserUI/setting.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late String useremail="625nisansala@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").where('email', isEqualTo: useremail).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  reverse: true,
                  itemCount: snapshot.data!.docs.length, // error
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];

                    return ListView(
                      // Remove padding
                      padding: EdgeInsets.zero,
                      children: [
                        UserAccountsDrawerHeader(
                          accountName: const Text('Oflutter.com'),
                          accountEmail: const Text('example@gmail.com'),
                          currentAccountPicture: CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              ),
                            ),
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.favorite),
                          title: Text('Favorites'),
                          onTap: () => null,
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Friends'),
                          onTap: () => null,
                        ),
                        ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text('Share'),
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyPurchersOrder()),
                            ),
                          },
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
                              MaterialPageRoute(
                                  builder: (context) => const setting()),
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
                      ],
                    );
                  },
                )
              : const Center();
        },
      ),
    );
  }
}
