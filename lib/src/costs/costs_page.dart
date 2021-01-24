import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warikan_native/src/costs/bloc/index.dart';
import 'package:warikan_native/src/costs/costs_list.dart';
import 'package:warikan_native/src/costs/edit_cost_page.dart';

class CostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildContents(context),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => EditCostPage.show(context, cost: null),
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return BlocBuilder<CostsBloc, CostsState>(
      builder: (context, state) {
        if (state is CostsLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is CostsLoaded) {
          return CostsListContent(model: state.costs);
        }

        return Container();
      },
    );
  }
}
