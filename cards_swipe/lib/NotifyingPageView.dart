import 'package:flutter/material.dart';

/*
  Note: This is the code copied from internet 
  (https://medium.com/flutter-community/synchronising-widget-animations-with-the-scroll-of-a-pageview-in-flutter-2f3475fcffa3) 
  and modified as per the need,
  The basic idea of the NotifyingPageView is that it normalize the page scroll,
  between 0 - 1 (left swipe) and 0 - (-1) (right swipe).
  This helps to find the correct offset that can be plugged directly to the a animation.
*/
class NotifyingPageView extends StatefulWidget {
  final ValueNotifier<double> notifier;
  final Function onPageChange;

  const NotifyingPageView({Key key, this.notifier, this.onPageChange})
      : super(key: key);

  @override
  _NotifyingPageViewState createState() => _NotifyingPageViewState();
}

class _NotifyingPageViewState extends State<NotifyingPageView> {
  int _previousPage;
  PageController _pageController;

  void _onScroll() {
    if (_pageController.page.toInt() == _pageController.page) {
      _previousPage = _pageController.page.toInt();
    }
    double value = _pageController.page - _previousPage;
    widget.notifier?.value = _pageController.page - _previousPage;
    if (value == 1 || value == 0) {
      widget.onPageChange(_pageController.page.toInt());
    }
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 1)..addListener(_onScroll);
    _previousPage = _pageController.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, position) {
        return Container(
          color: _getColorFor(position),
        );
      },
      itemCount: 3,
      controller: _pageController,
    );
  }

  Color _getColorFor(int index) {
    switch (index) {
      case 0:
        return Colors.yellow[100];
      case 1:
        return Colors.orange[100];
      case 2:
        return Colors.purple[100];
      default:
        return Colors.black;
    }
  }
}
