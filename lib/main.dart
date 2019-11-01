import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String debugLable = "Unknown";
  final JPush jPush = new JPush();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> initPlatformState() async{
    String platformVersion;

    try{
      jPush.addEventHandler(
        onReceiveNotification: (Map<String,dynamic> message) async{
          print(">>>>>>>>>接受推送${message}");
          setState(() {
            debugLable = "接受推送${message}";
          });

        }
      );
    } on PlatformException{
      platformVersion = "平台版本获取失败，请检查";
    }

    if(!mounted) return;
    setState(() {
      debugLable = platformVersion;
    });

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("极光推送"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text("结果：${debugLable}"),
              FlatButton(
                child: Text("发送推送信息"),
                onPressed: (){
                  var fireDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch+3000);
                  var loaclNotification = LocalNotification(
                    id:123,
                    title: "我是一条消息",
                    buildId: 1,
                    content: "看到就行",
                    fireTime: fireDate,
                    subtitle: "测试测试",
                  );
                  jPush.sendLocalNotification(loaclNotification).then((res){
                    setState(() {
                      debugLable = res;
                    });
                  });
                },
              )
            ],
          ),
        ),
      ),

    );
  }
}
