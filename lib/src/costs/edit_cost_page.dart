import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/custom_radio_button.dart';
import 'package:warikan_native/src/costs/models/burden_rate.dart';
import 'package:warikan_native/src/home/models.dart';
import 'package:warikan_native/src/services/database.dart';

class EditCostPage extends StatefulWidget {
  const EditCostPage({Key key, @required this.database, this.cost})
      : super(key: key);
  final Database database;
  final Cost cost;

  static Future<void> show(BuildContext context, {Cost cost}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditCostPage(database: database, cost: cost),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCostPageState createState() => _EditCostPageState();
}

class _EditCostPageState extends State<EditCostPage> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  int _amount;
  String _category;
  DateTime _paymentDate = DateTime.now();
  BurdenRate _burdenRate = BurdenRate.even();
  BurdenRateType _burdenRateType = BurdenRateType.even;
  final _paymentDateController = TextEditingController();

  @override
  void initState() {
    if (widget.cost != null) {
      _amount = widget.cost.amount;
      _category = widget.cost.category;
      _paymentDate = widget.cost.paymentDate;
    }
    _paymentDateController.value =
        TextEditingValue(text: _formatDate(_paymentDate));
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    if (_validateAndSaveForm()) {
      final id = widget.cost?.id ?? widget.database.documentIdFromCurrentDate();
      final cost = Cost(
        id: id,
        amount: _amount,
        category: _category,
        paymentDate: _paymentDate,
        burdenRate: _burdenRate,
      );
      await widget.database.setCost(cost);
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContents(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildContents() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.cost == null ? "自分の支払いを入力" : "編集",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 32.0,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormChildren()
          ..addAll(
            [
              SizedBox(height: 10.0),
              _buildSubmitButton(),
            ],
          ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    if (_isLoading == true) {
      return CircularProgressIndicator();
    }

    return FlatButton(
      child: Text(
        "保存",
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: _submit,
      shape: StadiumBorder(
        side: BorderSide(
          color: Theme.of(context).buttonTheme.colorScheme.primaryVariant,
          width: 1.6,
        ),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      _buildCostTypeRadioButtons(),
      TextFormField(
        decoration: InputDecoration(labelText: "金額"),
        initialValue: _amount != null ? "$_amount" : "",
        keyboardType: TextInputType.number,
        validator: (value) => value.isNotEmpty ? null : "金額を入力してください",
        onSaved: (value) => _amount = int.tryParse(value),
      ),
      TextFormField(
        initialValue: _category,
        decoration: InputDecoration(labelText: "カテゴリー"),
        onSaved: (value) => _category = value,
      ),
      FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(1900),
            maxTime: DateTime(2999),
            onConfirm: (date) {
              _paymentDate = date;
              _paymentDateController.value =
                  TextEditingValue(text: _formatDate(date));
            },
            currentTime: _paymentDate ?? DateTime.now(),
            locale: LocaleType.jp,
          );
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(labelText: "支払日"),
            controller: _paymentDateController,
          ),
        ),
      ),
    ];
  }

  String _formatDate(DateTime date) {
    return "${date.year}年${date.month}月${date.day}日";
  }

  Widget _buildCostTypeRadioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CustomRadioButtonGroup<BurdenRateType>(
          onChanged: (value) {
            setState(() {
              _burdenRateType = value;
              _burdenRate = _burdenRateType.toBurdenRate();
            });
          },
          models: [
            CustomRadioButtonModel(title: "割り勘", value: BurdenRateType.even),
            CustomRadioButtonModel(title: "貸した", value: BurdenRateType.partner),
          ],
          groupValue: _burdenRateType,
        )
      ],
    );
  }
}
