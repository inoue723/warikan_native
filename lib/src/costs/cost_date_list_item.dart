import 'package:flutter/material.dart';
import 'package:warikan_native/src/costs/bloc/costs_bloc.dart';
import 'package:warikan_native/src/models/cost.dart';

class CostDateListItem extends StatelessWidget {
  CostDateListItem({this.dateCosts});
  final DateCosts dateCosts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          _buildDateLabel(),
          _buildCostList(),
        ],
      ),
    );
  }

  Widget _buildDateLabel() {
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
            onPressed: () {},
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildCostList() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          _buildCostItem(),
          _buildCostItem(),
        ],
      ),
    );
  }

  Widget _buildCostItem() {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                // color from main theme
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "あなた",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Text("食費"),
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
            Text(
              "1500円",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
