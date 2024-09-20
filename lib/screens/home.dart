import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Clonner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(onPressed: (){
              Navigator.pushNamed(context,'/write');
            }, 
            color: Colors.blue,
            child: Text('Write NFC')),
            SizedBox(height: 15,),

            MaterialButton(onPressed: (){
              Navigator.pushNamed(context,'/read');
            }, 

            color: Colors.blue,
            child: Text('Read NFC')),
          ],
        ),
      ),
    );
  }
}
