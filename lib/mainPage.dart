import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

int _selected = 0;

List<String> titleText = ['블랙박스 기록', '페달 기록', 'RPM 기록'];
List<Widget> _selectedTop = [
  blackbox(), DrawData(kind: 0), DrawData(kind: 1)
];
List<String> saveName = ["blackbox.mp3","gagamsok.txt","hoejeonsu.txt"];

class _MainpageState extends State<Mainpage> {

  @override
  void initState()  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title : Text(titleText[_selected],style: TextStyle(fontSize: 30),),
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: Color.fromARGB(150, 0x02, 0x7D, 0xFD),
      ),

      body: Container(
        height: screenHeight-45,
        width: screenWidth,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: (screenHeight-45)/2,
              width: screenWidth,
              child: Stack(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: screenWidth,
                      height: (screenHeight-45)/2,
                      child: _selectedTop[_selected],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: (screenHeight-45)/2-60,width: screenWidth),
                      Row(
                        children: [
                          SizedBox(height: 60,width: screenWidth-60),

                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                Outsave();
                              },
                              icon: Icon(Icons.download_rounded),
                            ),
                          )
                        ],
                      )
                    ],
                  )

                ],
              )
            ),


            Expanded(
              child: Container(
                height: (screenHeight-45)/2,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(239, 190, 111,1),
                  borderRadius: BorderRadius.only(topLeft : Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for(int i = 0;i<3;i++) GestureDetector(
                      child: Container(
                        height: (screenHeight-45)/2/6.5,
                        width: screenWidth-50,
                        child: Text(titleText[i],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(50, 200, 200, 200),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                      ),
                      onTap: () {
                        setState(() {
                          _selected = i;
                          selecteditem = -1;
                        });
                      },
                    ),

                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}


//블랙박스 기록 창
class blackbox extends StatefulWidget {
  const blackbox({super.key});

  @override
  State<blackbox> createState() => _blackboxState();
}

class _blackboxState extends State<blackbox> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("assets/bb.mp4")
      ..initialize();
    _controller.play();
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }
}




class DrawData extends StatefulWidget {
  int kind;
  DrawData({required this.kind});

  @override
  State<DrawData> createState() => _DrawDataState();
}

int selecteditem = -1;
class _DrawDataState extends State<DrawData> {
  String url = '192.168.4.1';
  var itemcnt;
  var gotres;
  List<String> getKeyword = ['/brake','/rpm'];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    if(selecteditem == -1) {
      return FutureBuilder(
          future: getList(),
          builder: (BuildContext cxt, AsyncSnapshot snapshot) {
            debugPrint("futurebuilder !!!");
            debugPrint("data is : ${snapshot.data.toString()}");
            if(snapshot.hasData == false) {
              return CircularProgressIndicator();
            }
            else if (snapshot.hasError) {
              return Center(child :Text(snapshot.error.toString()));
            }
            else {
              debugPrint("sadfqsdfasdfads");

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ct, int idx) {
                  return GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Text(snapshot.data[idx].toString()),
                    ),
                    onTap: () {
                      setState(() {
                        selecteditem = idx;
                      });
                    },
                  );
                },
              );
            }
        }
      );
    }
    
    else {
      return FutureBuilder(
        future: readFile(),
        builder: (BuildContext cxt, AsyncSnapshot snapshot) {
          if(snapshot.hasData == false) {
            return CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return Center(child :Text(snapshot.error.toString()));
          }
          else {
            return Container(
              child: Text(snapshot.data),
            );
          }
        }
    );
    }
  }

  Future<dynamic> getList() async {
    debugPrint("start get List()");
    final queryUrl = Uri.parse("http://$url${getKeyword[widget.kind]}/list");
    debugPrint("!!!!!!$queryUrl");

    final res = await http.get(queryUrl);
    debugPrint("Result: ${res.body}");

    if (res.statusCode == 200) {
      debugPrint("gooooooooood connect!!!!!!!!!!!!");
      gotres = convert.jsonDecode(res.body) as dynamic;
      debugPrint("aaaaaa   ${gotres.runtimeType} ${gotres}");
      debugPrint(gotres.toString());
      return gotres;
    }
    else {
      debugPrint("error on getList");
      return ['error'];
    }
  }




  Future<String> readFile() async {


    var file = "";
    debugPrint("now valus is ${gotres[selecteditem]} !!!!!!!!!!!!!");
    var filename = gotres[selecteditem].toString().split("/")[3].substring(0,8);

    debugPrint("now valus is ${filename} !!!!!!!!!!!!!");
    final queryurl = "http://"+url+getKeyword[widget.kind]+"/get?filename="+filename;
    debugPrint("!!!!!!!!! ${queryurl.toString()}");
    var res = await http.get(Uri.parse(queryurl));
    if(res.statusCode == 200) {
      debugPrint(res.body.toString());
      var dir = await getApplicationDocumentsDirectory();
      File(dir.path+'/'+saveName[_selected]).writeAsStringSync(res.body);

      try {
        file = String.fromCharCodes(File('${dir.path}/${saveName[_selected]}').readAsLinesSync().map((e) => int.parse(e)).toList());
        debugPrint(file);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    else {
      debugPrint("something goes wrong");
    }
    return file;
  }
}

void Outsave() async{

  var dir = await getApplicationDocumentsDirectory();

  PickOrSave().fileSaver(
      params: FileSaverParams(
        saveFiles: [
          SaveFileInfo(
              filePath: dir.path+'/'+saveName[_selected],
              fileName: saveName[_selected])
        ],
      )
  );
}

void call119() async {
  await FlutterPhoneDirectCaller.callNumber("119");
}