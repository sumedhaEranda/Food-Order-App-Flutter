import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

void main() {
  runApp(const PlaceOrderScreen());
}

class PlaceOrderScreen extends StatelessWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Place Order'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  //edit controller
  final TextEditingController ProductNameController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final ProductNameField = TextFormField(
      autofocus: false,
      controller: ProductNameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.location_city),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Adress',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter  delivery Address");
        }
      },
      onSaved: (value) {
        ProductNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body:Stack(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: OpenStreetMapSearchAndPick(
                      center: LatLong(6.2683, 80.0898),
                      buttonColor: Colors.blue,
                      buttonText: 'Set Default Address',
                      onPicked: (pickedData) {

                      }),
                ),

            ]
          ),

    );
  }


}
