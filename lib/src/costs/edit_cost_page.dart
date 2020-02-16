import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/home/models.dart';
import 'package:warikan_native/src/services/database.dart';

class EditCostPage extends StatefulWidget {
  const EditCostPage({Key key, @required this.database, this.cost}) : super(key: key);
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

  @override
  void initState() {
    if (widget.cost != null) {
      _amount = widget.cost.amount;
      _category = widget.cost.category;
    }
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
      final cost = Cost(id: id, amount: _amount, category: _category, paymentDate: DateTime.now(),);
      await widget.database.setCost(cost);     
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: widget.cost == null ? Text("新規") : Text("詳細"),
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
        ));
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
    ];
  }
}
