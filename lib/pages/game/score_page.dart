import 'package:flutter/material.dart';
class ScorePage extends StatelessWidget{
  final int score;
  final Function reset;
  const ScorePage({
    super.key,
    required this.score,
    required this.reset,
  });
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:const Text('game')),
      body:Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "score: $score",
              style: TextStyle(
                fontSize : 30
              )
            ),
            ElevatedButton(
              onPressed:(){
                reset();
                Navigator.pop(context);
              },
              child:const Text(
                "戻る",
                style:TextStyle(
                  fontSize: 30
                )

                )
            ),
          ],
        ),
      ),
    );
  }
}