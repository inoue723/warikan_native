import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/custom_radio_button.dart';
import 'package:warikan_native/src/common_widgets/platform_alert_dialog.dart';
import 'package:warikan_native/src/common_widgets/platfrom_exption_alert_dialog.dart';
import 'package:warikan_native/src/models/burden_rate.dart';
import 'package:warikan_native/src/models/cost.dart';
import 'package:warikan_native/src/models/user.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/services/database.dart';

class EditCostPage extends StatefulWidget {
  const EditCostPage({
    Key key,
    @required this.database,
    this.cost,
    @required this.myUserInfo,
  }) : super(key: key);
  final Database database;
  final Cost cost;
  final User myUserInfo;

  static Widget create(BuildContext context, {Cost cost}) {
    final database = Provider.of<Database>(context, listen: false);
    final myUserInfo =
        Provider.of<AuthBase>(context, listen: false).currentUser();
    return EditCostPage(database: database, myUserInfo: myUserInfo);
  }

  static Future<void> show(BuildContext context, {Cost cost}) async {
    final database = Provider.of<Database>(context, listen: false);
    final myUserInfo =
        Provider.of<AuthBase>(context, listen: false).currentUser();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditCostPage(
            database: database, cost: cost, myUserInfo: myUserInfo),
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
  String _uid;
  int _amount;
  String _category;
  DateTime _paymentDate = DateTime.now();
  BurdenRate _burdenRate = BurdenRate.even();
  BurdenRateType _burdenRateType = BurdenRateType.even;
  final _paymentDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _uid = widget.myUserInfo.uid;

    if (widget.cost != null) {
      _uid = widget.cost.uid;
      _amount = widget.cost.amount;
      _category = widget.cost.category;
      _paymentDate = widget.cost.paymentDate;

      if (widget.cost.burdenRate != null) {
        _burdenRate = widget.cost.burdenRate;
        _burdenRateType = widget.cost.burdenRate.toBurdenRateType();
      }
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
        uid: _uid,
        amount: _amount,
        category: _category,
        paymentDate: _paymentDate,
        burdenRate: _burdenRate,
      );
      await widget.database.setCost(cost);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        // TODO: show toast successful message
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  widget.cost?.id == null ? "自分の支払いを入力" : "編集",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (Navigator.of(context).canPop())
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
                child: Column(
                  children: [
                    _buildForm(),
                    SizedBox(height: 10.0),
                    _buildSubmitButton(),
                    SizedBox(height: 10.0),
                    if (widget.cost?.id != null) _buildDeleteButton(),
                  ],
                ),
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
      child: Column(children: _buildFormChildren()),
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
            CustomRadioButtonModel(title: "貸した", value: BurdenRateType.lending),
          ],
          groupValue: _burdenRateType,
        )
      ],
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () => _delete(),
      child: Row(
        children: [
          Icon(
            Icons.delete,
          ),
          Text(
            "削除する",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Future<void> _delete() async {
    final didRequestDelete = await PlatformAlertDialog(
      title: "",
      content: "削除しますか？",
      cancelActionText: "いいえ",
      defaultActionText: "はい",
    ).show(context);

    if (didRequestDelete) {
      try {
        await widget.database.deleteCost(widget.cost);
        Navigator.of(context).pop();
      } on PlatformException catch (err) {
        PlatformExceptionAlertDialog(
          title: "削除に失敗しました",
          exception: err,
        );
      }
    }
  }
}
