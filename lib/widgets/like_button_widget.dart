import 'package:flutter/material.dart';

//点赞组件
class LikeButtonWidget extends StatefulWidget {
  bool isLike = false;
  Function onClick;

  LikeButtonWidget({Key key, this.isLike, this.onClick}) : super(key: key);

  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  double _size = 24.0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animation = Tween(begin: _size, end: _size * 0.5).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      child: null,
    );
  }
}

class _LikeAnimation extends AnimatedWidget {
  AnimationController controller;
  Animation animation;
  Function onClick;
  bool isLike = false;

  _LikeAnimation({this.controller, this.animation, this.isLike, this.onClick})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        isLike ? Icons.favorite : Icons.favorite_border,
        size: animation.value,
        color: isLike ? Colors.red : Colors.grey[600],
      ),
      onTapDown: (dragDownDetails) {
        controller.forward();
      },
      onTapUp: (dragDownDetails) {
        Future.delayed(Duration(milliseconds: 100), () {
          controller.reverse();
          onClick();
        });
      },
    );
  }
}
