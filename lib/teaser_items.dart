import 'package:flutter/material.dart';
import 'package:kiffi/homePage.dart';
import 'package:kiffi/signUp.dart';

//import 'package:banking_app/libraries/globals.dart' as globals;

final items = [
  new ItemViewModel(
    'images/teaserAsset3.png',
    'Titre 1',
    'Lorem ipsum dolor sit amet, nec ei alii dolorum. Summo iracundia ius ut',
    false
  ),
  new ItemViewModel(
    'images/teaserAsset2.png',
    'Titre 2',
    'Lorem ipsum dolor sit amet, nec ei alii dolorum. Summo iracundia ius ut',
    false
  ),
  new ItemViewModel(
    'images/teaserAsset3.png',
    'Titre 3',
    'Lorem ipsum dolor sit amet, nec ei alii dolorum. Summo iracundia ius ut',
    true
  ),
];

class Item extends StatelessWidget{

  final ItemViewModel viewModel;
  final double percentVisible;
  final bool isFadingOut;

  Item({
    this.viewModel,
    this.percentVisible = 1.0,
    this.isFadingOut,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.transparent,
      child: new Opacity(
        opacity: percentVisible,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 40.0),
              child: new Transform(
                transform: new Matrix4.translationValues(0.0, 50.0 * (1.0 - percentVisible), 0.0),
                child: new Padding(
                  padding: new EdgeInsets.only(bottom: 25.0),
                  child: new Image.asset(
                    viewModel.itemAssetPath,
                    color: const Color(0xFF00a8f6),
                    width: 200.0,
                    height: 200.0
                  ),
                ),
              ),
            ),
            new Center(
              child: new Transform(
                transform: new Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
                child: new Center(
                  child: new Padding(
                    padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: new Center(
                      child: new Text(
                        viewModel.title,
                        style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'LiberationSerif',
                          fontSize: 28.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            new Center(
              child: new Transform(
                transform: new Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
                child: new Center(
                  child: new Padding(
                    padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: new Center(
                      child: new Text(
                        viewModel.subtitle,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'LiberationSerif',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            new Center(
              child: viewModel.isLast
                ? new Transform(
                  transform: new Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
                  child: new Material(
                    color: Colors.transparent,
                    child: new Padding(
                      padding: new EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
                      child: new Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(4.0),
                          border: new Border.all(
                            color: const Color(0xFF00a8f6),
                            width: 4.0,
                          )
                        ),
                        width: double.infinity,
                        height: 60.0,
                        child: new InkWell(
                          splashColor: const Color(0xFF00a8f6).withOpacity(0.3),
                          onTap: (){
                            Navigator.of(context)
                              ..push(new MaterialPageRoute(
                                  builder: (BuildContext context) => new SignUp(),
                              ));
                          },
                          child: new Center(
                            child: new Text(
                              'Commencer maintenant',
                              style: new TextStyle(
                                color: const Color(0xFF00a8f6),
                                fontSize: 20.0,
                                fontFamily: 'LiberationSerif',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                )
                : new Container(
                    height: 100.0,
                  ),
            )
          ],
        ),
      ),
    );
  }
}

enum SlideDirection{
  leftToRight,
  rightToLeft,
  none,
}

class ItemViewModel{
  final String itemAssetPath;
  final String title;
  final String subtitle;
  final bool isLast;

  ItemViewModel(
    this.itemAssetPath,
    this.title,
    this.subtitle,
    this.isLast,
  );
}