import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warikan_native/src/common_widgets/custom_raised_buddon.dart';
import 'package:warikan_native/src/costs/empty_content.dart';
import 'package:warikan_native/src/invitation/bloc/invitation_bloc.dart';
import 'package:warikan_native/src/invitation/invitation_page.dart';
import 'package:warikan_native/src/models/cost_summary.dart';
import 'package:warikan_native/src/costs/cost_date_list_item.dart';

class CostsListContent extends StatelessWidget {
  const CostsListContent({Key key, @required this.model}) : super(key: key);
  final CostsSummary model;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildSummaryLabel(),
          _buildLendOrBorrowAmountText(),
          if (model.costs.isEmpty)
            Column(
              children: [
                SizedBox(height: 200),
                EmptyContent(),
              ],
            ),
          Column(
            children: _buildCostList(context),
          )
        ],
      ),
    );
  }

  Widget _buildLendOrBorrowAmountText() {
    return BlocBuilder<InvitationBloc, InvitationState>(
      builder: (context, state) {
        if (model.costs.isEmpty) return Container();
        if (state is InvitationNotInvited) {
          return RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black87),
              children: [
                TextSpan(
                  text: "合計 ",
                ),
                TextSpan(
                  text: "${model.totalCostAmount}",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                TextSpan(
                  text: "円",
                ),
              ],
            ),
          );
        }

        final amount = model.borrowAmount.isNegative
            ? model.borrowAmount * -1
            : model.borrowAmount;
        final color = model.borrowAmount > 0 ? Colors.red : Colors.green;
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$amount",
                style: TextStyle(fontSize: 20, color: color),
              ),
              TextSpan(
                text: "円",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        );
      },
    );
  }

  Iterable<Widget> _buildCostList(BuildContext context) {
    return List.generate(model.dateList.length, (index) {
      return CostDateListItem(dateCosts: model.dateList[index]);
    });
  }

  Widget _buildSummaryLabel() {
    return BlocBuilder<InvitationBloc, InvitationState>(
      builder: (context, state) {
        if (state is InvitationNotInvited) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: CustomeRaisedButton(
              child: Text(
                "相手を招待しましょう",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<InvitationBloc>(context),
                      child: InvitationPage(),
                    ),
                  ),
                );
              },
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        return RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.grey, fontSize: 14),
            children: [
              TextSpan(
                text: model.borrowAmount < 0 ? "貸してる" : "借りてる",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              TextSpan(
                text: "金額",
              )
            ],
          ),
        );
      },
    );
  }
}
