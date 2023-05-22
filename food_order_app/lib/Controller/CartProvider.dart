import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cartProvider extends ChangeNotifier{
  List<double> adprice=[];
  int _counter=0;

  int get counter =>_counter;
  double _totalprice=0.0;
  double get totalprice =>_totalprice;
  List<double> tot=[];
  void addcounter(){
    _counter++;
    _selfprefItem();
    notifyListeners();
  }

  void _selfprefItem() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble('total_price', _totalprice);
    notifyListeners();
  }
  void _getfprefItem() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    _totalprice=pref.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addtotalprice(double productprice)
  {
    _totalprice=_totalprice+productprice;
    _selfprefItem();
    notifyListeners();
  }

  double getTotalprice()   {
    FirebaseFirestore.instance
        .collection('productcart')
        .get()
        .then((querySnapshot) {

      querySnapshot.docs.forEach((element) async {
        double value=element.data()['item_price'];
        _totalprice = _totalprice + value/2;
      }
      );
    });
    _getfprefItem();
    return _totalprice;
  }




  void removeotalprice(double pprice){


    _totalprice=_totalprice-pprice;
    _selfprefItem();
    notifyListeners();
  }
}