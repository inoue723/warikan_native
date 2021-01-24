import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warikan_native/src/common_widgets/custom_raised_buddon.dart';
import 'package:warikan_native/src/costs/bloc/index.dart';
import 'package:warikan_native/src/costs/cost_date_list_item.dart';
import 'package:warikan_native/src/costs/empty_content.dart';
import 'package:warikan_native/src/invitation/bloc/invitation_bloc.dart';
import 'package:warikan_native/src/invitation/invitation_page.dart';

// floatingActionButton: FloatingActionButton(
//   backgroundColor: Theme.of(context).primaryColor,
//   child: Icon(
//     Icons.add,
//     color: Colors.white,
//   ),
//   onPressed: () => EditCostPage.show(context, cost: null),
// ),
class CostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CostsBloc, CostsState>(
        builder: (context, state) {
          if (state is CostsLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is CostsLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildSummaryLabel(state),
                  _buildLendOrBorrowAmountText(state),
                  if (state.costs.isEmpty)
                    Column(
                      children: [
                        SizedBox(height: 200),
                        EmptyContent(),
                      ],
                    ),
                  Column(
                    children: _buildCostList(context, state),
                  )
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildSummaryLabel(CostsLoaded costState) {
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
                text: costState.borrowAmount < 0 ? "貸してる" : "借りてる",
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

  Widget _buildLendOrBorrowAmountText(CostsLoaded costState) {
    return BlocBuilder<InvitationBloc, InvitationState>(
      builder: (context, state) {
        if (costState.costs.isEmpty) return Container();
        if (state is InvitationNotInvited) {
          return RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black87),
              children: [
                TextSpan(
                  text: "合計 ",
                ),
                TextSpan(
                  text: "${costState.totalCostAmount}",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                TextSpan(
                  text: "円",
                ),
              ],
            ),
          );
        }

        final amount = costState.borrowAmount.isNegative
            ? costState.borrowAmount * -1
            : costState.borrowAmount;
        final color = costState.borrowAmount > 0 ? Colors.red : Colors.green;
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

  Iterable<Widget> _buildCostList(BuildContext context, CostsLoaded costState) {
    return List.generate(costState.dateList.length, (index) {
      return CostDateListItem(dateCosts: costState.dateList[index]);
    });
  }
}
