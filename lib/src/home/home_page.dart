import 'package:flutter/material.dart';
import 'package:warikan_native/src/chart/chart_page.dart';
import 'package:warikan_native/src/costs/costs_page.dart';
import 'package:warikan_native/src/costs/edit_cost_page.dart';
import 'package:warikan_native/src/settings/setting_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      CostsPage(),
      EditCostPage.create(context),
      ChartPage(),
      SettingPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: '一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mode_edit),
            label: '記録',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: '分析',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black45,
        unselectedLabelStyle: TextStyle(color: Colors.black45),
        onTap: _onItemTapped,
      ),
    );
  }
}
