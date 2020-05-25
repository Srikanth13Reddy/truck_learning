
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truck_learning/widgets/loading_overlay.dart';

class CustomProgressBar extends StatelessWidget {
  final bool isLoading;
  final Widget widget;

  CustomProgressBar({
    @required this.isLoading,
    @required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LoadingOverlay(
      opacity: 1,
      color: Colors.black12,
      isLoading: isLoading,
      progressIndicator: CupertinoActivityIndicator(
        radius: 15,
        animating: true,
      ),
      child: widget,
    );
  }
}
