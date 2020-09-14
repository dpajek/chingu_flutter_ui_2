import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:universal_platform/universal_platform.dart'
    show UniversalPlatform;


class ActivityIndicator extends StatelessWidget {

  ActivityIndicator({Key key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator();
  }
}


/*
class PlatformScaffold extends StatelessWidget {
  PlatformScaffold({Key key, @required this.title, @required this.body})
      : super(key: key);

  final Widget title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: title,
            ),
            child: body,
          )
        : Scaffold(
            appBar: AppBar(
              title: title,
            ),
            body: body,
          );
  }
}
*/

/*
class PlatformInkWell extends StatelessWidget {

  PlatformInkWell({Key key, @required this.onTap, this.child})
      : super(key: key);

  final Widget child;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return !UniversalPlatform.isIOS
        ? CupertinoButton(
            onPressed: onTap,
            child: child,
            padding: EdgeInsets.zero
          )
        : InkWell(
            onTap: onTap,
            child: child,
          );
  }
}*/
