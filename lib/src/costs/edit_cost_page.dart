import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  int _amount;
  String _category;
  DateTime _paymentDate = DateTime.now();
  final _paymentDateController = TextEditingController();

  @override
  void initState() {
    if (widget.cost != null) {
      _amount = widget.cost.amount;
      _category = widget.cost.category;
      _paymentDate = widget.cost.paymentDate;
    }
    _paymentDateController.value = TextEditingValue(text: _formatDate(_paymentDate));
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
    if (_validateAndSaveForm()) {
      final id = widget.cost?.id ?? widget.database.documentIdFromCurrentDate();
      final cost = Cost(
        id: id,
        amount: _amount,
        category: _category,
        paymentDate: _paymentDate,
      );
      await widget.database.setCost(cost);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: widget.cost == null ? Text("新規") : Text("編集"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "保存",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
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
              _paymentDateController.value = TextEditingValue(text: _formatDate(date));
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
}
