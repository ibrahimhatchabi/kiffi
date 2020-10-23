
import 'dart:ui';

import 'package:kiffi/teaser_items.dart';
import 'package:flutter/material.dart';

//import 'package:kasata/pages.dart';

class ItemPagerIndicator extends StatelessWidget {

  final ItemIndicatorViewModel viewModel;

  ItemPagerIndicator({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {

    List<PageBubble> bubbles = [];
    for (var i = 0; i < viewModel.items.length; ++i){
      final item = viewModel.items[i];

      var percentActive;
      if (i == viewModel.activeIndex){
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 && viewModel.slideDirection == SlideDirection.leftToRight){
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 && viewModel.slideDirection == SlideDirection.rightToLeft){
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      /*bool isHollow = i > viewModel.activeIndex
          || (i == viewModel.activeIndex && viewModel.slideDirection == SlideDirection.leftToRight);*/
      bool isHollow = i != viewModel.activeIndex;

      bubbles.add(
        new PageBubble(
          viewModel: new PageBubbleViewModel(
            item.itemAssetPath,
            const Color(0xFF00a8f6),
            isHollow,
            percentActive,
          ),
        ),
      );
    }

    final BUBBLE_WIDTH = 15.0;
    final baseTranslation = ((viewModel.items.length * BUBBLE_WIDTH) / 2) - (BUBBLE_WIDTH / 2);
    var translation = baseTranslation - (viewModel.activeIndex * BUBBLE_WIDTH);
    if (viewModel.slideDirection == SlideDirection.leftToRight){
      translation += BUBBLE_WIDTH * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft){
      translation -= BUBBLE_WIDTH * viewModel.slidePercent;
    }

    return new Column(
      children: <Widget>[
        new Expanded(child: new Container()),
        new Transform(
          transform: new Matrix4.translationValues(0.0, 0.0, 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        ),
      ],
    );
  }
}

class ItemIndicatorViewModel{
  final List<ItemViewModel> items;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  ItemIndicatorViewModel(
      this.items,
      this.activeIndex,
      this.slideDirection,
      this.slidePercent
      );
}

class PageBubble extends StatelessWidget {

  final PageBubbleViewModel viewModel;

  PageBubble({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(3.0),
      child: new Container(
        width: 12.0,
        height: 15.0,
        child: new Center(
          child: new Container(
            width: lerpDouble(20.0, 45.0, viewModel.activePercent),
            height: lerpDouble(20.0, 45.0, viewModel.activePercent),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: viewModel.isHollow
                    ? const Color(0xFF00a8f6).withAlpha((0x88 * viewModel.activePercent).round())
                    : const Color(0xFF00a8f6).withAlpha((0x88 * viewModel.activePercent).round()),
                border: new Border.all(
                  color: viewModel.isHollow
                      ? const Color(0xFF00a8f6).withAlpha((0x88 * (1.0 - viewModel.activePercent)).round())
                      : const Color(0xFF00a8f6).withAlpha((0x88 * (1.0 - viewModel.activePercent)).round()),
                  width: 1.5,
                )
            ),
            child: new Opacity(
              opacity: viewModel.activePercent,
              child: new Padding(
                padding: new EdgeInsets.all(5.0),
                child: new Container()
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class PageBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
      this.iconAssetPath,
      this.color,
      this.isHollow,
      this.activePercent
      );
}
