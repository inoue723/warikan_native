import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent(
      {Key key,
      this.title = "コンテンツがありません",
      this.message = "＋ボタンからアイテムを作成してください"})
      : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 30,
            ),
          ),
          Text(
            message,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
