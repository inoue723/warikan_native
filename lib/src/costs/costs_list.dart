import 'package:flutter/material.dart';
import 'package:warikan_native/src/home/models.dart';

class CostsListTile extends StatelessWidget {
  const CostsListTile({Key key, @required this.cost, this.onTap}) : super(key: key);
  final Cost cost;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cost.category),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}