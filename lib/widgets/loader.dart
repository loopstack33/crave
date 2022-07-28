import 'package:crave/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProgressHUD extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;

  const ProgressHUD({
    Key? key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = AppColors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = Stack(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Lottie.asset("assets/raw/doubleheart.json"),
            ),
          )
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
