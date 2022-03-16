import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar_example/Provider/AirTableBuySell.dart';
import 'package:table_calendar_example/utils.dart';

import '../Provider/AirTableApi.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Map<DateTime, List<Event>> _listEvent = {};

  void didChangeDependencies() {
    _listEvent = Provider.of<AirTableApi>(context).iteams;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List a = [];
    var c = Provider.of<AirTableBuySell>(context, listen:  true).iteams;
   int todayDay = DateTime.now().day;
    var listOfDates =
        new List<DateTime>.generate(todayDay, (i) => DateTime.utc(2022, 3, i+1));
    listOfDates.forEach((value) {
      a.add(SalesData(
          value.day.toString() + '-' + value.month.toString(),
          (_listEvent[value] == null)
              ? 200.0
              : double.tryParse(_listEvent[value]![0].title) ?? 200));
    });
    var d = DateTime.utc(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    print(d);
    int e = _listEvent[d] == null ? 300 : int.parse(_listEvent[d]!.first.title);

    return Scaffold(
        appBar: AppBar(title: Text('Dashboard')),
        body: Center(
            child: Column(
          children: [
            UserUpdate(c: c, e: e),
            StockGraph(a: a),
            CallToActionWidget(c: c, e:e),
          ],
        )));
  }
}

class CallToActionWidget extends StatefulWidget {
  const CallToActionWidget({
    Key? key,
    required this.c,
    required this.e
  }) : super(key: key);

  final List c;
  final int e;

  @override
  State<CallToActionWidget> createState() => _CallToActionWidgetState();
}

class _CallToActionWidgetState extends State<CallToActionWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
  List d = Provider.of<AirTableBuySell>(context).iteams;

    print(3253245);
    print(widget.c);
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: EdgeInsets.all(5),
          child: Card(
            child: _isLoading?CircularProgressIndicator():Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (d.isEmpty) 
                  ElevatedButton(onPressed: () {
                    Provider.of<AirTableBuySell>(context, listen:  false).createrecord(widget.e);
                  }, child: Text('Buy'))
                else if (d.length == 1)
                  ElevatedButton(onPressed: () {
                    Provider.of<AirTableBuySell>(context, listen:  false).createrecord(widget.e);

                  }, child: Text('Sell'))
                  else  
                  ElevatedButton(onPressed: () {
                         setState((){
_isLoading = true;
                      });
                    Provider.of<AirTableBuySell>(context, listen:  false).reset().whenComplete(() {
                      setState((){
_isLoading = false;
                      });
                    });

                  }, child: Text('Reset'))

                  

              ],
            )
          )),
    );
  }
}

class StockGraph extends StatelessWidget {
  const StockGraph({
    Key? key,
    required this.a,
  }) : super(key: key);

  final List a;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
          child: SfCartesianChart(
              // Initialize category axis
              primaryXAxis: CategoryAxis(),
              series: <LineSeries<SalesData, String>>[
            LineSeries<SalesData, String>(
                // Bind data source

                dataSource: <SalesData>[...a],
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales)
          ])),
    );
  }
}

class UserUpdate extends StatelessWidget {
  const UserUpdate({
    Key? key,
    required this.c,
    required this.e,
  }) : super(key: key);

  final List c;
  final int e;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: EdgeInsets.all(5),
          child: Card(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text((c.isEmpty
                    ? 'You haven\'t buyed the stock yet'
                    : 'Stock Buyed Date - ' +
                        c.first.first.toString().substring(0, 10) +
                        '\n' +
                        'Amount Rs ' +
                        c.first[1].toString())),
                SizedBox(height: 10,),
                Text('Today Stock price Rs ' + '$e'),
                if (c.isNotEmpty)
                  Text(('Profit/Loss ' +
                      (e * 10 - c.first[1]).toString() +
                      ' Rs'))
              ],
            )),
          )),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
