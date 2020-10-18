import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:otistories/views/home_view/home_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartView extends StatefulWidget {
  @override
  _StartViewState createState() => new _StartViewState();
}

class _StartViewState extends State<StartView> {
  SharedPreferences localStorage;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('note_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ));
    setAlerm();

    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  _checkTimer() {
    Future.delayed(Duration(seconds: 5), () async {
      await Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => HomeView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          // padding: const EdgeInsets.all(20),
          color: Colors.red[100].withOpacity(.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: height / 3,
                child: Image.asset(
                  'assets/LogoOti.png',
                ),
              ),
              Text('Oti Stories',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown[900],
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                '...experience the supernatural\nas you go through our posts today!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 50,
              ),
              SpinKitFadingCube(
                size: 25,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.red[900] : Colors.red,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  showDailyNotification() async {

    await Permission.notification.request();
    print('running ');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Hello 👋',
        "Today's Story and  Prayers have been posted. Enjoy💃",
        RepeatInterval.EveryMinute,
        platformChannelSpecifics);
  }

 

  setAlerm() async {
    localStorage = await SharedPreferences.getInstance();
    await localStorage.setBool('setAlerm', true);
    //--------------
    localStorage = await SharedPreferences.getInstance();
    if (localStorage.getBool('setAlerm') == true) {
      showDailyNotification();
      print('set timer');
      _checkTimer();
    } else {
      print('runing from set');
      _checkTimer();
    }
  }
}
