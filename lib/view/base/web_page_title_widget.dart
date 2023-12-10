import 'package:flutter/material.dart';
import 'package:quickad_it_solutions/helper/responsive_helper.dart';
import 'package:quickad_it_solutions/util/styles.dart';

class WebScreenTitleWidget extends StatelessWidget {
  final String title;
  const WebScreenTitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? Container(
            height: 64,
            color: Theme.of(context).primaryColor.withOpacity(0.10),
            child: Center(child: Text(title, style: robotoMedium)),
          )
        : const SizedBox();
  }
}
