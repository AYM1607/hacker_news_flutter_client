import 'package:flutter/material.dart';

class LoadingTile extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: getContainer(),
          subtitle: getContainer(),
        ),
        Divider(),
      ],
    );
  }

  Widget getContainer() {
    return Container(
      color: Colors.grey[300],
      height: 24,
      width: 150,
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
    );
  }
}
