import 'package:flutter/material.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spinKit = SpinKitWave(
      itemBuilder: (BuildContext context, int index) {
        return const DecoratedBox(
          decoration: BoxDecoration(color: Pallete.secondaryColor),
        );
      },
    );
    return spinKit;
  }
}
