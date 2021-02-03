import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'GlassRect.dart';

main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    )
  );
}

class HomeScreen extends StatefulWidget {
  String _secret = 'xxx';
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int temperature;
  String location;
  String images = 'images/clear.png';
  String iconID;
  String errorMsg;

  void _requests(String city) async {
    String url = 'https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${widget._secret}&units=metric';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      _setRelevant(result);
    } else {
      setState(() {
        this.errorMsg = 'Sorry we couldn\'t find your location.';
      });
    }
  }

  void _setRelevant(Map decodedResp){
    setState(() {
      this.errorMsg = '';
      this.images = 'images/${decodedResp['weather'][0]['main'].toLowerCase()}.png';
      this.temperature = decodedResp['main']['temp'].round();
      this.location = '${decodedResp['name']}, ${decodedResp['sys']['country']}';
      this.iconID = decodedResp['weather'][0]['icon'];
    });
  }

  @override
  void initState() {
    super.initState();
    _requests('Surabaya');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(this.images),
              fit: BoxFit.cover
            )
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black26
        ),
        temperature == null ? 
        Center(child: CircularProgressIndicator()) :
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.network('http://openweathermap.org/img/wn/${this.iconID}@2x.png'),
                      Text('${this.temperature.toString()} °C',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white
                      ),
                      ),
                      Text(this.location,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassRect(
                        borderRadius: BorderRadius.circular(30),
                        child: TextField(
                          onSubmitted: (String input) => this._requests(input),
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 16
                         ),
                         decoration: InputDecoration(
                           hintText: 'Search another location',
                           hintStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: 16
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))
                         ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child:Text(this.errorMsg,
                                  style: TextStyle(color: Colors.red[400])
                        )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}