import 'package:flutter/material.dart';

import 'NotifyingPageView.dart';

class CardAnimation extends StatefulWidget {
  @override
  _CardAnimationState createState() => _CardAnimationState();
}

class _CardAnimationState extends State<CardAnimation> {
  ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  double leftPadding = 0;
  double screenWidth = 0;
  int currentPage = 1;
  double cardWidth = 250;
  double animationThreshold = 0.6;
  bool shouldIgnorePointer = false;
  // double halfMultipler

  @override
  void initState() {
    super.initState();
    _notifier.addListener(() {
      setState(() {
        calculateLeftPadding();
      });
    });
  }

  void calculateLeftPadding() {
    if (currentPage == 1) {
      getOffsetDuringCenterScroll();
    } else if (currentPage == 2) {
      getOffsetDuringRightScroll();
    } else if (currentPage == 0) {
      getOffsetDuringLeftScroll();
    }
  }

  void getOffsetDuringLeftScroll() {
    if (_notifier.value > 0) {
      double value = _notifier.value < animationThreshold
          ? _notifier.value
          : animationThreshold;

      /* 
        Q. Again a new value 1.1 can you explain what is this??
        A. We are currently on the left,
           when we moved from center to right our offset was 0.6.
           So, (0.6 - 1.1) = -0.5 (To move the card to center we need 0.5).
      */
      leftPadding = (screenWidth * (1.1 - value)) - (cardWidth / 2);
    }
  }

  void getOffsetDuringRightScroll() {
    if (_notifier.value < 0) {
      double value = _notifier.value > -animationThreshold
          ? _notifier.value
          : -animationThreshold;

      /* 
        Q. What does this 0.1 indicate here??
        A. We are currently on the right,
           when we moved from center to right our offset was 0.6.
           So, (0.6 - 0.1) = 0.5 (To move the card to center we need 0.5).
      */
      leftPadding = (screenWidth * (-0.1 - value)) - (cardWidth / 2);
    }
  }

  void getOffsetDuringCenterScroll() {
    if (_notifier.value > 0) // Left Swipe
    {
      /* 
        Animation will be from 0 to 1, 
         but we will move till 0.6, that is the threshold
      */
      double value = _notifier.value < animationThreshold
          ? _notifier.value
          : animationThreshold;

      /* 
        Always the animation offset is subtracted from the 0.5 
        because we are moving the card from the center 
      */
      leftPadding = (screenWidth * (0.5 - value)) - (cardWidth / 2);
    } else if (_notifier.value < 0) // Right Swipe
    {
      /* Animation will be from 0 to 1, 
         but we will move till 0.6, that is the threshold
      */
      double value = _notifier.value > -animationThreshold
          ? _notifier.value
          : -animationThreshold;

      /* 
        Always the animation offset is subtracted from the 0.5 
        because we are moving the card from the center 
      */
      leftPadding = (screenWidth * (0.5 - value)) - (cardWidth / 2);
    }
  }

  @override
  void didChangeDependencies() {
    screenWidth = MediaQuery.of(context).size.width;

    // Calculate initial padding to make the card on the center
    // 1. First part Denotes the half of the screen size
    // 2. Subtract half of the card width to get the correct Y position
    leftPadding = (screenWidth * 0.5) - (cardWidth / 2);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        NotifyingPageView(
          notifier: _notifier,
          onPageChange: (currenIndex) {
            currentPage = currenIndex;
          },
        ),
        Positioned(
          top: 100,
          left: leftPadding,
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              height: 400,
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(const Radius.circular(10)),
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
    ));
  }
}
