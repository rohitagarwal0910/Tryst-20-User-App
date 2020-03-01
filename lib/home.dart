import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:tryst_20_user/infoscreen.dart';
import 'categories/categories_tab.dart';
import 'globals.dart';

import './events/events_tab.dart';
// import './clubs/clubs_tab.dart';
import 'userlogin/profile_icon.dart';

class HomeScreen extends StatefulWidget {
  final Function onlogout;

  HomeScreen({this.onlogout});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _controller;
  int _selectedTab = 0;
  List<Widget> _tabs;
  List<BottomNavigationBarItem> _navBarItems;

  Widget appBar;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
    appBar = GradientAppBar(
      elevation: 10,
      title: Row(children: [
        Image.asset(
          'assets/trystlogowhite.png',
          height: 25,
        ),
        Container(
          width: 10,
        ),
        Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.w400),
        )
      ]),
      backgroundColorStart: Colors.indigo,
      backgroundColorEnd: Colors.cyan[600],
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InfoScreen()));
            }),
        ProfileIcon(widget.onlogout)
      ],
      // bottom: TabBar(
      //   indicatorColor: Colors.white70,
      //   controller: _controller,
      //   tabs: [
      //     Tab(text: 'PREFEST'),
      //     Tab(text: 'DAY 1'),
      //     Tab(text: 'DAY 2'),
      //     Tab(text: 'DAY 3'),
      //   ],
      // ),
    );
    _tabs = [CategoriesTab(), EventsTab(_controller)];
    _navBarItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.line_weight),
        title: Text('Events'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event),
        title: Text('Schedule'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      body: _tabs[_selectedTab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: BottomNavigationBar(
          elevation: 1,
          backgroundColor: Colors.indigo[400].withOpacity(1),
          selectedItemColor: Colors.lightBlueAccent[100],
          unselectedItemColor: Colors.white.withOpacity(0.6),
          currentIndex: _selectedTab,
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
              if (index == 1)
                appBar = GradientAppBar(
                  title: Row(children: [
                    Image.asset(
                      'assets/trystlogowhite.png',
                      height: 25,
                    ),
                    Container(
                      width: 10,
                    ),
                    Text(
                      '$title',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    )
                  ]),
                  backgroundColorStart: Colors.indigo,
                  backgroundColorEnd: Colors.cyan[600],
                  elevation: 10,
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InfoScreen()));
                        }),
                    ProfileIcon(widget.onlogout)
                  ],
                  bottom: TabBar(
                    indicatorColor: Colors.white70,
                    controller: _controller,
                    tabs: [
                      Tab(text: 'PREFEST'),
                      Tab(text: 'DAY 1'),
                      Tab(text: 'DAY 2'),
                      Tab(text: 'DAY 3'),
                    ],
                  ),
                );
              else
                appBar = GradientAppBar(
                  title: Row(children: [
                    Image.asset(
                      'assets/trystlogowhite.png',
                      height: 25,
                    ),
                    Container(
                      width: 10,
                    ),
                    Text(
                      '$title',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    )
                  ]),
                  elevation: 10,
                  backgroundColorStart: Colors.indigo,
                  backgroundColorEnd: Colors.cyan[600],
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InfoScreen()));
                        }),
                    ProfileIcon(widget.onlogout)
                  ],
                );
            });
          },
          items: _navBarItems,
        ),
      ),
    );
  }
}
