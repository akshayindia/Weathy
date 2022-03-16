

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:studiovity/Providers/download_provider.dart';
// import 'package:studiovity/Screens/Global%20Component/DownloadwithProgress.dart';
import 'package:table_calendar_example/pages/Home.dart';
import 'Provider/AirTableApi.dart';
import 'Provider/AirTableBuySell.dart';


Future<void> main() async {

  return runApp(MyApp());
}

 class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProxyProvider0<AirTableApi>(
            create: (context) => AirTableApi({}, {}), 
          update: (ctx, previousProject) => AirTableApi( 
            previousProject == null ? {}: previousProject.iteams, previousProject == null ? {}: previousProject.iteamId 
          ),),
            ChangeNotifierProxyProvider0<AirTableBuySell>(
            create: (context) => AirTableBuySell({}), 
          update: (ctx, previousProject) => AirTableBuySell( 
            previousProject == null ? {}: previousProject.iteams,
          ),)
        ],
        child: Builder(builder: (BuildContext context) {

        return MaterialApp(
                debugShowCheckedModeBanner: false,

                home: Home(),
                routes: {
                  
                });
          
        }));
  }
}

