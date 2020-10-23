import 'package:flutter/material.dart';
import 'package:kiffi/homePage.dart';
import 'package:kiffi/librairies/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  State createState() => new _State();

}


class _State extends State<SignUp>{

  static final TextEditingController _telephone = new TextEditingController();
  static final TextEditingController _nomComplet = new TextEditingController();
  String indicatif;
  String _helperText = globals.phoneNumberHelperText;

  TextStyle _myInputTextStyle = new TextStyle(
    fontFamily: globals.generalFontFamily,
    fontSize: globals.generalFontSize,
    color: Colors.black,
  );
  TextStyle _myHintTextStyle = new TextStyle(
    //fontFamily: globals.generalFontFamily,
    fontSize: globals.generalFontSize,
    color: Colors.black,
  );
  bool isEnabled = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  Widget build(BuildContext context) {

    return new Container(
      color: Colors.white,
      child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue,
            elevation: 0.0,
            title: new Text(
              "${globals.appTitle}",
              style: new TextStyle(
                //fontWeight: FontWeight.bold,
                fontFamily: globals.generalFontFamily,
                fontSize: globals.generalFontSize,
              ),
            ),
          ),
          body: new Center(
              child: new Form(
                //padding: new EdgeInsets.all(30.0),
                  key: _formKey,
                  child: new ListView(
                    shrinkWrap: false,
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
                    children: <Widget>[
                      new Text(
                        "Enregistrez vous",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontFamily: globals.generalFontFamily,
                          fontSize: globals.labelsFontSize,
                        ),
                      ),

                      new Container(
                        padding: new EdgeInsets.all(10.0),
                        child: new TextFormField(
                          validator: (value){
                            if(value.length < 12){
                              return globals.incorrectPhoneNumber;
                            } else if(!isNumeric(value)){
                              return globals.incorrectPhoneNumber;
                            }
                          },
                          keyboardType: TextInputType.phone,
                          controller: _telephone,
                          style: _myHintTextStyle,
                          decoration: new InputDecoration(
                            hintText: globals.phoneNumberHintText,
                            hintStyle: _myHintTextStyle,
                            helperText: globals.phoneNumberHelperText,
                          ),
                        ),
                      ),

                      new Container(
                        padding: new EdgeInsets.all(10.0),
                        child: new TextFormField(
                          style: _myHintTextStyle,
                          controller: _nomComplet,
                          decoration: new InputDecoration(
                            hintText: globals.fullNameHintText,
                            hintStyle: _myHintTextStyle,
                            helperText: globals.fullNameHelperText,
                          ),
                        ),
                      ),

                      new Container(
                          padding: new EdgeInsets.all(30.0),
                          child:
                          new Padding(
                            padding: new EdgeInsets.only(left: 40.0, right: 40.0),
                            child: new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: new BorderRadius.circular(4.0),
                                  border: new Border.all(
                                    color: Colors.blue,
                                    width: 4.0,
                                  )
                              ),
                              width: double.infinity,
                              height: 60.0,
                              child: new InkWell(
                                splashColor: isEnabled
                                    ? Colors.blue
                                    : Colors.transparent,
                                onTap:(){
                                  String telephone = '+221${_telephone.text}';
                                  //TODO: Insert contact into firebase database
                                  DocumentReference document = Firestore.instance.collection("Contacts").document();

                                  Firestore.instance.runTransaction((transaction) async {
                                    await transaction.set(document, {'nomComplet':_nomComplet.text,'telephone':telephone});
                                  });

                                  Navigator.of(context)
                                    ..push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new HomePage(),
                                    ));

                                },
                                child: new Center(
                                  child: new Text(
                                    globals.continueButton,
                                    style: new TextStyle(
                                      color: Colors.blue,
                                      fontFamily: globals.generalFontFamily,
                                      fontSize: globals.buttonsFontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      )
                    ],
                  )
              )
          )
      ),
    );
  }
}