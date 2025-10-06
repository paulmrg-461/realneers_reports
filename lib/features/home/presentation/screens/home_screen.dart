import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  final int? initialIndex;
  const HomeScreen({super.key, this.initialIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialIndex ?? 0;
    _index = (initial >= 0 && initial <= 1) ? initial : 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final titles = [
      context.tr('home.reports'),
      context.tr('home.profile'),
    ];

    final pages = [
      Center(child: Text(context.tr('home.reports'))),
      Center(child: Text(context.tr('home.profile'))),
    ];

    if (isDesktop) {
      return Scaffold(
        appBar: AppBar(title: Text(titles[_index])),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.assignment),
                  label: Text(context.tr('home.reports')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.person),
                  label: Text(context.tr('home.profile')),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: pages[_index]),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text(context.tr('app.title'))),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: Text(context.tr('home.reports')),
              onTap: () {
                setState(() => _index = 0);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(context.tr('home.profile')),
              onTap: () {
                setState(() => _index = 1);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment),
            label: context.tr('home.reports'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: context.tr('home.profile'),
          ),
        ],
      ),
    );
  }
}