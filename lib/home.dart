import 'package:flutter/material.dart';
import 'login_page.dart'; // Import your LoginPage
import 'register_page.dart'; // Import your RegisterPage

class Home extends StatefulWidget {
  final int initialTabIndex;

  const Home({super.key, this.initialTabIndex = 0});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _selectedIndex,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Row(
            children: [
              Text(
                "Social ",
                style: TextStyle(color: Colors.white,fontSize: 30),
              ),
              Text(
                "X",
                style: TextStyle(color: Colors.white,fontSize: 50),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.grey,
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Color(0xFFBBBBBB),
                      tabs: [
                        Tab(
                          text: 'Login',
                        ),
                        Tab(
                          text: 'Signup',
                        ),
                      ],
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        LoginPage(),
                        RegisterPage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
