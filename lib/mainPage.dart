import 'package:flutter/material.dart';

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

class _MainpageState extends State<Mainpage> {
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

            Expanded(
                child: Container(
                  height: (screenHeight-45)/2,
                  width: screenWidth,
                  child: _selectedTop[_selected],
                ),
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

