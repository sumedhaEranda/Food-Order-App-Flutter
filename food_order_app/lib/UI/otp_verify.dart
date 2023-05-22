import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'login.dart';


class Otpverify extends StatefulWidget {
  const Otpverify({Key? key}) : super(key: key);

  @override
  State<Otpverify> createState() => _OtpverifyState();
}

class _OtpverifyState extends State<Otpverify> {

  //form key
  final _formKey =GlobalKey<FormState>();
  //edit controller
  final TextEditingController phoneController= TextEditingController();
  final TextEditingController otpController= TextEditingController();

  //firebase
  final _auth =FirebaseAuth.instance;
  final String smsCode = '';

  late String _verCode;
  late double _formHeight;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var _verificationId;

  var _status = Status.waiting;


  @override
  Widget build(BuildContext context) {


    final phoneField= TextFormField(

      autofocus: false,
      controller: phoneController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          prefixIcon:const Icon(Icons.mail),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Phone Number',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0))),
      validator: (value){
        if(value!.isEmpty){
          return ("Please enter your Email");
        }
        //reg expression for email validation
        if(!RegExp(r'/^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/').hasMatch(value)){
          return  ("Please enter valid phone number");
        }
        return null;
      },
      onSaved: (value){
        phoneController.text=value!;
      },
    );


    final OtpField= TextFormField(

      autofocus: false,
      controller: otpController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0))),
      validator: (value){
        if(value!.isEmpty){
          return ("Please enter Otp");
        }
        return null;
      },
      onSaved: (value){
        otpController.text=value!;
      },
    );




    return Container(

      decoration:const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bbclck.png'),fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left:35,top: 130 ),
              child: const Text('Email\nVerification',style: TextStyle(
                  color:  Colors.white,
                  fontSize: 33
              ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height *0.2,
                    right: 35,
                    left: 35),
                child:Form(
                  key: _formKey,
                  child: Column(
                    children:  [ const Image(image:AssetImage('assets/code_image.png'),height: 300,width: 300,),
                      phoneField,
                      const SizedBox(
                        height:20,
                      ),
                      OtpField,
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(onPressed: () {_verifyPhoneNumber();},
                              child: const Text(
                                'Send the Code ',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              )) ,
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [const Text('Verify',style: TextStyle(
                            fontSize: 27,fontWeight: FontWeight.bold,color: Colors.white
                        ),
                        ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xff4c505b),
                            child: IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.arrow_forward),
                              onPressed:() { verifyOtp();
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _verifyPhoneNumber() async {
    _auth.verifyPhoneNumber(
        phoneNumber: '+94${phoneController.text}',
        verificationCompleted: (phonesAuthCredentials) async {},
        verificationFailed: (verificationFailed) async {},
        codeSent: (verificationId, reseningToken) async {
          setState(() {
            verificationId = verificationId;
            print(verificationId); // here I am printing the opt code so I will know what it is to use it
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          setState(() {

            verificationId = verificationId;

          });
        });
  }




  void verifyOtp(){

    if(otpController.text==smsCode){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const MyLogin()));
    }

  }

}
enum Status { waiting, error }