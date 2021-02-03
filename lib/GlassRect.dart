import 'package:flutter/material.dart';
import 'dart:ui';

class GlassRect extends StatefulWidget {
  double horizontalBlur;
  double verticalBlur;

  BorderRadius borderRadius;

  Widget child;

  GlassRect({
    this.child,
    this.horizontalBlur = 3,
    this.verticalBlur = 3,
    this.borderRadius
  });

  @override
  _GlassRectState createState() => _GlassRectState();
}

class _GlassRectState extends State<GlassRect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.horizontalBlur,
            sigmaY: widget.verticalBlur,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white10,
            ),
            child: widget.child
          )
        ),
      )
    );
  }
}