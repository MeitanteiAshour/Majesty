import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subtlenavbar/MajestySwipeNav/swipenav_controller.dart';

class MajestySwipeNavigationBar extends StatefulWidget {
  final Color backgroundColor;
  final Color selectorColor;
  final Color selectedItemColor;
  final Color nonSelectedIconColor;
  final Curve animationCurve;
  final Duration animationDuration;
  final List<Widget> items;
  final List<String> captions;
  final TextStyle captionsTextStyle;
  final double swipedHeight;
  final ValueChanged<int> onItemPressed;
  MajestySwipeNavigationBar({
    @required this.items,
    @required this.captions,
    @required this.onItemPressed,
    this.swipedHeight = 120.0,
    this.captionsTextStyle = const TextStyle(color: Colors.white),
    this.backgroundColor = const Color(0xff422FBC),
    this.selectorColor = const Color(0xFFFFFFFF),
    this.nonSelectedIconColor,
    this.selectedItemColor,
    this.animationCurve = Curves.easeInSine,
    this.animationDuration = const Duration(milliseconds: 500),
  })  : assert(items.length == captions.length),
        assert(items.length >= 2);

  @override
  _MajestySwipeNavigationBarState createState() =>
      _MajestySwipeNavigationBarState();
}

class _MajestySwipeNavigationBarState extends State<MajestySwipeNavigationBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<SwipeNavController>(
      builder: (_, _bloc, __) => AnimatedContainer(
        duration: widget.animationDuration,
        color: widget.backgroundColor,
        curve: widget.animationCurve,
        height: _bloc.show ? widget.swipedHeight : 80,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.items
                .asMap()
                .map(
                  (int index, Widget iconItem) => MapEntry(
                    index,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                          _bloc.show = false;
                        });
                        widget.onItemPressed(_currentIndex);
                      },
                      child: Container(
                        width: 30,
                        height: widget.swipedHeight,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              bottom: 10,
                              child: IconTheme(
                                data: IconThemeData(
                                  color: _currentIndex == index
                                      ? widget.selectedItemColor
                                      : widget.nonSelectedIconColor,
                                ),
                                child: iconItem,
                              ),
                            ),
                            Positioned(
                              bottom: (MediaQuery.of(context).size.width -
                                  widget.swipedHeight??50) / 2.5,
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: Text(
                                  '${widget.captions[index]}',
                                  softWrap: false,
                                  style: widget.captionsTextStyle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}
