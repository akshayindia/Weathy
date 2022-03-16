 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar_example/Provider/AirTableApi.dart';
import 'package:table_calendar_example/Provider/AirTableBuySell.dart';
import 'package:table_calendar_example/pages/Calender.dart';

import 'Dashboard.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   int _currentIndex = 0;
    var _isint = true;
    bool _isLoading = true;

  @override
  void didChangeDependencies() {
    if(_isint){
    Provider.of<AirTableBuySell>(context).listrecords();
    Provider.of<AirTableApi>(context).listrecords().then((value) => 
    setState((){
      _isLoading = false;
    })
    );

    

    }
    _isint = false;
    super.didChangeDependencies();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [
      Chart(),

  // TableBasicsExample(),
     TableEventsExample(),
    //  TableMultiExample(),
    //  TableComplexExample()
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                onTap: onTabTapped, // new
                currentIndex: _currentIndex,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.calendar_today_outlined
                    ),
                    label: 'Calender',
                  ),
                
                ],
                selectedItemColor: Theme.of(context).colorScheme.primary,
              ),
            
     
      body: _isLoading? Center(child: CircularProgressIndicator()): Center(
                    child: _children.elementAt(_currentIndex),
                  ),
      

    );
  }
}