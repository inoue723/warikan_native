import 'package:flutter/material.dart';
import 'package:warikan_native/src/costs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ContainerBuilder<T> extends StatelessWidget {
  const ContainerBuilder(
      {Key key, @required this.snapshot, @required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<T> snapshot;
  final ItemWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final T item = snapshot.data;
      return Container(
        child: itemBuilder(context, item),
      );
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: "読み込み中にエラーが発生しました",
        message: "もう一度お試しください",
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
