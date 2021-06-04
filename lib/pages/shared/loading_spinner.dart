import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {

  final bool isButtonLoading;

  LoadingSpinner({this.isButtonLoading = false});

  @override
  Widget build(BuildContext context) {
    return isButtonLoading ? Container(
        color: Colors.amber[600],
        child: SpinKitThreeBounce(color:  Colors.grey[50], size: 10.0))
        :  Container(
        color: Colors.grey[50],
        child: SpinKitThreeBounce(color: Colors.amber[600], size: 60.0));
  }
}
