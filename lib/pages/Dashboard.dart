import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar_example/Provider/AirTableBuySell.dart';
import 'package:table_calendar_example/utils.dart';
import 'package:table_calendar_example/utils/customdividerview.dart';
import 'package:table_calendar_example/utils/uihelper.dart';

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
        appBar: AppBar(title: Text('Wealthy Dashboard')),
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

class CallToActionWidget extends StatelessWidget {
  const CallToActionWidget({
    Key? key,
    required this.c,
    required this.e
  }) : super(key: key);

  final List c;
  final int e;

  @override
  Widget build(BuildContext context) {
    print(3253245);
    print(c);
    return Expanded(
      
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(5),
              child:  (c.isEmpty) ?
                Card(
                  child: ListTile( leading: Icon(Icons.apple_outlined),
                              // tileColor: Colors.grey.shade300,
                  trailing: 
                   ElevatedButton(child: Text('Buy'), onPressed: (){
                    Provider.of<AirTableBuySell>(context, listen:  false).createrecord(e);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Congratulations You\'ve brought 10 unit of WEALTHY Stocks',
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 5),
                          ));
                   },),
                   title: Text('WEALTHY'),
                   subtitle: Text('Rs $e'),
                   
                   ),
                )
              :(c.length == 1)?
              Card(
                  child: ListTile( leading: Icon(Icons.apple_outlined,),
                              // tileColor: Colors.grey.shade300,
                  trailing: 
                   ElevatedButton(child: Text('Sell'), onPressed: (){
                                      Provider.of<AirTableBuySell>(context, listen:  false).createrecord(e);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Congratulations You\'ve sold 10 unit of WEALTHY Stocks',
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 5),
                          ));
                   },),
                   title: Text('WEALTHY'),
                   subtitle: Text('Rs $e'),
                   
                   ),
                )
               
                :
                ElevatedButton(onPressed: () {
                  Provider.of<AirTableBuySell>(context, listen:  false).reset().whenComplete(() {
                  });

                }, child: Text('Reset'))),
                
        ],
      ),
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
    return SizedBox(
      height: MediaQuery.of(context).size.height/4,
      child: Card(
          child: SfCartesianChart(
                plotAreaBorderWidth: 0,
            // plotAreaBackgroundColor: Colors.green,
            // borderColor: Colors.green,
            plotAreaBorderColor: Colors.green,
              // Initialize category axis
              primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            borderColor: Colors.green
              ),
            //    primaryYAxis: CategoryAxis(
            // majorGridLines: const MajorGridLines(width: 1),
            // borderColor: Colors.green
            //   ),
                // title: ChartTitle(text: 'WEALTHY - 2022'),
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
final textStyle =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16.0);

    return Container(
      padding: const EdgeInsets.all(20.0),
      child: (c.isEmpty)? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Details',
            style:
                Theme.of(context).textTheme.headline6!.copyWith(fontSize: 17.0),
          ),
          UIHelper.verticalSpaceSmall(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('You haven\'t buyed any Stock', style: textStyle),])]):
      
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Details',
            style:
                Theme.of(context).textTheme.headline6!.copyWith(fontSize: 17.0),
          ),
          UIHelper.verticalSpaceSmall(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Purchase Date', style: textStyle),
              Text(c.first.first.toString().substring(0, 10), style: textStyle),
            ],
          ),
           UIHelper.verticalSpaceSmall(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Stock Price', style: textStyle),
              Text( (c.first[1]/10).toString(), style: textStyle),
            ],
          ),
          UIHelper.verticalSpaceSmall(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Quantity', style: textStyle),
              Text('10', style: textStyle),
            ],
          ),
          
          UIHelper.verticalSpaceLarge(),
          _buildDivider(),
          Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Row(
              children: <Widget>[
                Text('Purchased Amount', style: textStyle),
                UIHelper.horizontalSpaceSmall(),
                const Icon(Icons.info_outline, size: 14.0),
                const Spacer(),
                Text('Rs ' +  c.first[1].toString(), style: textStyle),
              ],
            ),
          ),
          _buildDivider(),
          Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Row(
              children: <Widget>[
                Text('Net P/L for Today', style: Theme.of(context).textTheme.subtitle2),
                const Spacer(),
                Text('Rs ' +  (e * 10 - c.first[1]).toString(), style: textStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomDividerView _buildDivider() => CustomDividerView(
        dividerHeight: 1.0,
        color: Colors.grey[400],
      );
}
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height / 4,
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//           padding: EdgeInsets.all(5),
//           child: Card(
//             child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text((c.isEmpty
//                     ? 'You haven\'t buyed the stock yet'
//                     : 'Stock Buyed Date - ' +
//                         c.first.first.toString().substring(0, 10) +
//                         '\n' +
//                         'Amount Rs ' +
//                         c.first[1].toString())),
//                 SizedBox(height: 10,),
//                 Text('Today Stock price Rs ' + '$e'),
//                 if (c.isNotEmpty)
//                   Text(('Profit/Loss ' +
//                       (e * 10 - c.first[1]).toString() +
//                       ' Rs'))
//               ],
//             )),
//           )),
//     );
//   }
// }

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
