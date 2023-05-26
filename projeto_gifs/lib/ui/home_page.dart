import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search ="";
  int _offset =0;


 Future<Map> _getGifs() async{
    http.Response  response;

    if(_search == null){
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=5f9rWNWTacdF6td0zKTKrCwv7mp71JKe&limit=20&rating=g");
    }
    else{
     response= await http.get("https://api.giphy.com/v1/gifs/search?api_key=5f9rWNWTacdF6td0zKTKrCwv7mp71JKe&q=$_search&limit=19&offset=$_offset&rating=g&lang=en");
    }
    return json.decode(response.body);

  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map){

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://cdn.folhape.com.br/img/pc/1100/1/dn_arquivo/2022/10/giphy-2.jpg"),
        centerTitle: true,

      ),
    backgroundColor: Colors.black,
        body: Column(
            children: <Widget>[
             Padding(padding: EdgeInsets.all(10),
              child: TextField(
                decoration:  InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(
                  color: Colors.white,
                  )
                ),
                style: TextStyle(color:Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
                onSubmitted: (text){
                  setState((){
                    _search=text;
                    _offset=0;
                  });


                },
            ),
        ),
              Expanded(
                  child: FutureBuilder(
                      future: _getGifs(),
                      builder: (content, snapshot){
                        switch(snapshot.connectionState){
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Container(
                              width: 200,
                              height: 200,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 5.0,
                              ),
                            );
                          default:
                            if(snapshot.hasError)return Container();
                            else {
                              return _creatGifsTable(context,snapshot);
                            }
                        }
                        }

                  ),
              ),
            ]
        ) ,
    );
  }

  int _getCount(List data){

   if(_search ==null){
     return data.length;

   }else{
     return data.length+1;

   }

  }

  Widget _creatGifsTable(BuildContext context,AsyncSnapshot snapshot) {
   return GridView.builder(
     padding: EdgeInsets.all(10),
     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
       crossAxisCount: 2,
       crossAxisSpacing: 10,
       mainAxisSpacing: 10
     ),
     itemCount: _getCount(snapshot.data["data"]),
     itemBuilder: (context,index){
       if(_search==null || index< snapshot.data["data"].length)
       return GestureDetector(
         child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
         height: 600.0,
             fit: BoxFit.cover


         )
       );
       else{
         return Container(
           child: GestureDetector(
             child: Column(
               children: [
                 Icon(Icons.add,color:Colors.white,size:70),
                 Text("Carregar mais...",style: TextStyle(color:Colors.white, fontSize: 22.0),)
               ],

             ),
           )
         );
       }
     }
     ,

   );

 }



}
