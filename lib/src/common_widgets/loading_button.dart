import 'package:flutter/material.dart';

import 'custom_raised_buddon.dart';

class LoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomeRaisedButton(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}
