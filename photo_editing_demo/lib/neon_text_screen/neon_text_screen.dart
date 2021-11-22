import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neon/neon.dart';

class NeonText extends StatefulWidget {
  const NeonText({Key? key}) : super(key: key);

  @override
  _NeonTextState createState() => _NeonTextState();
}

class _NeonTextState extends State<NeonText> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "Text",
              ),
            ),

            GestureDetector(
              onTap: (){
                print(textController.text);
                neonText(textController);
              },
              child: Container(
                height: 40, width: Get.width/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blue
                ),
                child: Center(
                  child: Text("OK", style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
            Neon(
              text: textController.text,
              color: Colors.green,
              fontSize: 50,
              font: NeonFont.Membra,
              flickeringText: true,
              flickeringLetters: [0,1],
            )
            //Text(textController.text)
          ],
        ),
      ),
    );
  }

  neonText(TextEditingController textController){
    return Container(
      child: Text(textController.text),
    );
  }
}
