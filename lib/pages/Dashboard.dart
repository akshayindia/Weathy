import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar_example/Provider/AirTableBuySell.dart';
import 'package:table_calendar_example/utils.dart';

import '../Provider/AirTableApi.dart';


class Chart extends StatefulWidget {
  const Chart({ Key? key }) : super(key: key);

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
 var c = Provider.of<AirTableBuySell>(context).iteams;
 
 var listOfDates = new List<DateTime>.generate(31, (i) => DateTime.utc(2022,3, i));
 listOfDates.forEach((value){
  a.add(SalesData(value.day.toString() + '-' + value.month.toString(), (_listEvent[value] == null)? 200.0: double.tryParse(_listEvent[value]![0].title) ?? 200));   
 });
var d = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
print(d);
int e = _listEvent[d] == null? 300 : int.parse(_listEvent[d]!.first.title );

  return Scaffold(
    appBar: AppBar(title: Text('Dashboard')),
    body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/4, width:  MediaQuery.of(context).size.width, child:  Padding( padding: EdgeInsets.all(5),
              child: Card(
                child:  Center(child: Column(
                  children: [
                    Text (
                      (c.isEmpty? 'You havn\'t buyed the stock yet':
                    
                    
                      'Stock Buyed Date - ' + c.keys.first.toString().substring(0,10) + '\n' + 'Amount Rs ' + c.values.first.toString() )),
               
               if(c.isNotEmpty)
                 Text( ('Profit/Loss ' +  (e*10 - c.values.first ).toString() + ' Rs'))
                  ],
                )),
              )),),
            Expanded(
              child: Card(
                child: SfCartesianChart(
                  // Initialize category axis
                  primaryXAxis: CategoryAxis(),
            
                  series: <LineSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                      // Bind data source
                      
                      dataSource:  <SalesData>[
                     ...a
                      ],
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales
                    )
                  ]
                )
              ),
            ),
           
            SizedBox(height: MediaQuery.of(context).size.height/4, width: MediaQuery.of(context).size.width , child:  Padding( padding: EdgeInsets.all(5),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (c.isEmpty)
                    ElevatedButton(onPressed: (){
                      

                    }, child: Text('Buy')), 
                    if(c.length == 1)
                    ElevatedButton(onPressed: (){}, child: Text('Sell'))],),
              )),),
          ],
        )
      )
  );

  
}
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}


