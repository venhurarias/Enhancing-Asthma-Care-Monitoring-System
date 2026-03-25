import 'package:flutter/material.dart';

import '../../constants.dart';


class MyCardGridView extends StatelessWidget {
  const MyCardGridView({Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.children = const <Widget>[],
    this.physics,
    this.padding
  }) : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  final List<Widget> children;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: padding,
      physics: physics??NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      children:children,
    );
  }
}
