import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/constants/colors.dart';
import 'package:warikan_native/src/costs/bloc/costs_bloc.dart';
import 'package:warikan_native/src/costs/edit_cost_page.dart';
import 'package:warikan_native/src/models/cost.dart';
import 'package:warikan_native/src/models/user.dart';
import 'package:warikan_native/src/services/auth.dart';

class CostDateListItem extends StatelessWidget {
  CostDateListItem({this.dateCosts});
  final DateCosts dateCosts;

  @override
  Widget build(BuildContext context) {
    final myUserInfo = Provider.of<AuthBase>(context).currentUser();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          _buildDateLabel(context, myUserInfo),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: dateCosts.costs
                  .map((cost) => _buildCostItem(context, cost, myUserInfo))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateLabel(BuildContext context, User myUserInfo) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[400]),
        ),
      ),
      constraints: BoxConstraints(maxHeight: 40),
      child: Row(
        children: [
          Text(
            dateCosts.date,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              EditCostPage.show(
                context,
                cost: Cost(
                  uid: myUserInfo.uid,
                  paymentDate: DateTime.parse(dateCosts.date),
                ),
              );
            },
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildCostItem(BuildContext context, Cost cost, User myUserInfo) {
    final bool isMine = cost.uid == myUserInfo.uid;
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          EditCostPage.show(
            context,
            cost: cost,
          );
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMine ? myLabelColor : partnerLabelColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                isMine ? "あなた" : "あいて",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(cost.category),
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
            Text(
              cost.amount.toString() + "円",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
