import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiffi/item_reveal.dart';
import 'package:kiffi/teaser_items.dart';
import 'package:kiffi/item_dragger.dart';
import 'package:kiffi/item_fade_out.dart';
import 'package:kiffi/item_pager_indicator.dart';

TextStyle myStyle = new TextStyle(
//fontWeight: FontWeight.bold,
  fontFamily: 'LiberationSerif',
  fontSize: 20.0,
);

class TeaserPage extends StatefulWidget {

  @override
  TeaserPageState createState() {
    return new TeaserPageState();
  }
}

class TeaserPageState extends State<TeaserPage> with WidgetsBindingObserver, TickerProviderStateMixin{
  @override
  void initState() {
    super.initState();

    //_time = new OctalDateTime.now().toLocal();
    //_time = new DateTime.now();

    // We want to update 4 times per second
    // so we can display millisecond values as well
    /*const duration = const Duration(
        milliseconds: OctalDuration.MILLISECONDS_PER_SECOND ~/ 4);
    // Our periodic timer for when to update our time
    _timer = new Timer.periodic(duration, _updateTime);
*/
    WidgetsBinding.instance.addObserver(this);

  }


  @override
  void dispose() {
    // Make sure to cancel the timer when we dispose the view
    WidgetsBinding.instance.removeObserver(this);
    //_timer.cancel();
    super.dispose();
  }

  /*void _updateTime(Timer _) {
    // Update our state with the new time and force a redraw
    setState(() {
      _time = new DateTime.now();
    });
  }*/

  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  TeaserPageState(){
    slideUpdateStream = new StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event){
      setState((){
        if(event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if(slideDirection == SlideDirection.leftToRight){
            nextPageIndex = activeIndex - 1;
          } else if(slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }

        }
        else if(event.updateType == UpdateType.doneDragging){
          if(slidePercent > 0.5){
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );

            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();

        } else if (event.updateType == UpdateType.animating) {
          //print('Sliding ${event.direction} at ${event.slidePercent}');
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

        } else if (event.updateType == UpdateType.doneAnimating) {
          //print('Done animating. Next page index: $nextPageIndex');
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          animatedPageDragger.dispose();
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: new Container(
            color: const Color(0xFF19222b),
            //padding: new EdgeInsets.all(15.0),
            child: new Scaffold(
              backgroundColor: Colors.transparent,
              body: new Container(
                padding: new EdgeInsets.all(5.0),
                child: new Center(
                  child: new DraggableScreen(
                      activeIndex: activeIndex,
                      widget: widget,
                      slidePercent: slidePercent,
                      nextPageIndex: nextPageIndex,
                      slideDirection: slideDirection,
                      slideUpdateStream: slideUpdateStream
                  ),
                ),
              ),
            )
        )
    );
  }
}

class DraggableScreen extends StatelessWidget {
  const DraggableScreen({
    Key key,
    @required this.activeIndex,
    @required this.widget,
    @required this.slidePercent,
    @required this.nextPageIndex,
    @required this.slideDirection,
    @required this.slideUpdateStream,
  }) : super(key: key);

  final int activeIndex;
  final TeaserPage widget;
  final double slidePercent;
  final int nextPageIndex;
  final SlideDirection slideDirection;
  final StreamController<SlideUpdate> slideUpdateStream;

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new ItemFadeOut(
          revealPercent: slidePercent,
          slideDirection: slideDirection,
          child: new Item(
            viewModel: items[activeIndex],
            percentVisible: 1.0 - slidePercent,
            isFadingOut: true,
          ),
        ),
        new ItemReveal(
          revealPercent: slidePercent,
          child: new Item(
            viewModel: items[nextPageIndex],
            percentVisible: slidePercent,
            isFadingOut: false,
          ),
          slideDirection: slideDirection,
        ),
        new ItemPagerIndicator(
          viewModel: new ItemIndicatorViewModel(
            items,
            activeIndex,
            slideDirection,
            slidePercent,
          ),
        ),
        new ItemDragger(
          canDragLeftToRight: activeIndex > 0,
          canDragRightToLeft: activeIndex < items.length - 1,
          slideUpdateStream: this.slideUpdateStream,
        ),
      ],
    );
  }
}
