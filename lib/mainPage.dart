import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pick_or_save/pick_or_save.dart';


class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

int _selected = 0;

List<String> titleText = ['블랙박스 기록', '가감속 기록', '회전수 기록'];
List<Widget> _selectedTop = [
  blackbox(), gagamsok(), hoejeonsu()
];
List<String> saveName = ["blackbox.mp3","gagamsok.txt","hoejeonsu.txt"];

class _MainpageState extends State<Mainpage> {

  @override
  void initState()  {
    super.initState();

    getApplicationDocumentsDirectory().then((value) {
      for(int i = 0;i<3;i++)
        File(value.path + '/' + saveName[i]).openWrite(mode: FileMode.append).write("");
    });
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
      ),

      body: Container(
        height: screenHeight-45,
        width: screenWidth,

        child: Column(
          children: [
            Container(
              height: (screenHeight-45)/2,
              width: screenWidth,
              child: Stack(
                children: [
                  _selectedTop[_selected],
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

            Divider(thickness: 1,color: Colors.black,indent: 15,endIndent: 15,),

            Expanded(
              child: Container(
                height: (screenHeight-45)/2,
                width: screenWidth,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    for(int i = 0;i<3;i++) GestureDetector(
                      child: Container(
                        height: (screenHeight-45)/2/6.5,
                        width: screenWidth-50,
                        child: Text(titleText[i],style: TextStyle(fontSize: 20),),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(199, 175, 175, 175),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                      ),
                      onTap: () {
                        setState(() {
                          _selected = i;
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
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.yellow);
  }
}


//가감속 기록 창
class gagamsok extends StatelessWidget {
  const gagamsok({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blue);
  }
}

//회전수 기록 창
class hoejeonsu extends StatelessWidget {
  const hoejeonsu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green);
  }
}

// 파일 쓰기
void writeFile(String s) async {
  // 내부 저장소의 경로를 가져올 때 getTemporaryDirectory() 함수를 이용할 수 있으나, 임시 디렉터리는 캐시를 이용하므로 앱이 종료되고 일정 시간이 지나면 사라질 수 있다.
  var dir = await getApplicationDocumentsDirectory();
  File(dir.path + '/' + saveName[_selected]).openWrite(mode: FileMode.append).write(s+"/n");
}

// 파일 읽기
void readFile() async {
  try {
    var dir = await getApplicationDocumentsDirectory();
    var file = await File(dir.path + '/'+saveName[_selected]).readAsString();
    print(file);
  } catch (e) {
    print(e.toString());
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

