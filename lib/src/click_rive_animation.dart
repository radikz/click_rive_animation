import 'controller/position_controller.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'model/position.dart';
import 'model/source.dart';

/// Create click animation with rive
class ClickRiveAnimation extends StatefulWidget {
  ///  The child contained by the click animation rive.
  final Widget? child;

  /// The width of animation.
  /// The default will be 100
  final double? width;

  /// The height of animation.
  /// The default will be 100
  final double? height;

  /// The animation name of rive
  final String animationName;

  /// The asset name or url
  final String name;

  final Source src;

  /// Creates a new ClickRiveAnimation from an asset bundle
  const ClickRiveAnimation.asset(this.name,
      {Key? key,
      required this.animationName,
      required this.child,
      this.width = 100,
      this.height = 100})
      : src = Source.asset,
        super(key: key);

  const ClickRiveAnimation.network(this.name,
      {Key? key,
      required this.animationName,
      required this.child,
      this.width = 100,
      this.height = 100})
      : src = Source.network,
        super(key: key);

  const ClickRiveAnimation.file(this.name,
      {Key? key,
      required this.animationName,
      required this.child,
      this.width = 100,
      this.height = 100})
      : src = Source.file,
        super(key: key);

  @override
  State<ClickRiveAnimation> createState() => _ClickRiveAnimationState();
}

class _ClickRiveAnimationState extends State<ClickRiveAnimation> {
  late RiveAnimationController _startAnimationController;
  final _controller = PositionController();

  late RiveAnimation _riveAnimation;

  @override
  void initState() {
    _startAnimationController =
        OneShotAnimation(widget.animationName, autoplay: false);
    switch (widget.src) {
      case Source.asset:
        _riveAnimation = RiveAnimation.asset(
          widget.name,
          controllers: [
            _startAnimationController,
          ],
        );
        break;
      case Source.network:
        _riveAnimation = RiveAnimation.network(
          widget.name,
          controllers: [
            _startAnimationController,
          ],
        );
        break;
      default:
        _riveAnimation = RiveAnimation.file(
          widget.name,
          controllers: [
            _startAnimationController,
          ],
        );
    }
    super.initState();
  }

  @override
  void dispose() {
    _startAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child!,
        StreamBuilder<Position>(
            stream: _controller.position,
            builder: (context, snapshot) {
              final dx = snapshot.data?.dx;
              final dy = snapshot.data?.dy;
              return Positioned(
                left: dx,
                top: dy,
                width: widget.width,
                height: widget.height,
                child: _riveAnimation,
              );
            }),
        GestureDetector(
          onTapDown: (details) {
            _startAnimationController
              ..isActive = false
              ..isActive = true;
            _controller.changePosition(
                details.localPosition.dx - widget.width! / 2,
                details.localPosition.dy - widget.height! / 2);
          },
        ),
      ],
    );
  }
}
