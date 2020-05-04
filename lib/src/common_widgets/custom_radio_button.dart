import 'package:flutter/material.dart';

class CustomRadioButtonGroup<T> extends StatefulWidget {
  final List<CustomRadioButtonModel> models;
  final T groupValue;
  final void Function(T value) onChanged;

  const CustomRadioButtonGroup({
    Key key,
    @required this.models,
    @required this.groupValue,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _CustomRadioButtonGroupState<T> createState() => _CustomRadioButtonGroupState<T>();
}

class _CustomRadioButtonGroupState<T> extends State<CustomRadioButtonGroup<T>> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Row(
        children: List.generate(widget.models.length, (index) {
          final model = widget.models[index];
          return _buildCustomButton(
            model.title,
            widget.groupValue,
            model.value,
          );
        }),
      ),
    );
  }

  Widget _buildCustomButton(
    String title,
    T groupValue,
    T value,
  ) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => widget.onChanged(value),
      child: Container(
        color: isSelected ? Theme.of(context).accentColor : Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              )),
        ),
      ),
    );
  }
}

class CustomRadioButtonModel<T> {
  final String title;
  final T value;

  CustomRadioButtonModel({@required this.title, @required this.value});
}
