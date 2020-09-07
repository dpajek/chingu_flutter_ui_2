import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // used for http requests
import 'dart:convert'; // provides the json converter

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<List<Article>> futureArticles;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles('');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 400), //max width on search
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      //enabledBorder: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).focusColor),
                      ),
                      hintText: 'Search',
                      //contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onSubmitted: (searchTerm) {
                      futureArticles = fetchArticles(searchTerm);
                      //print('Here is a new term: $searchTerm');
                      setState(() {
                        futureArticles = fetchArticles(searchTerm);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: futureArticles,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    (snapshot.connectionState == ConnectionState.done)) {
                  //return Text(snapshot.data[0].title);
                  List<Article> arts = snapshot.data;

/*
                  print(arts.length);
                  print(arts[2].title);
                  print(arts[2].author);
                  print(arts[14].urlToImage);
                  print(snapshot.connectionState.toString());
                  */

                  return ListView.builder(
                      itemCount: arts.length,
                      itemBuilder: (context, index) {
                        Article art = arts[index];

                        //print(index);

                        return Container(
                          height: 60,
                          child: ListTile(
                            leading: art.urlToImage == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(art.urlToImage),
                                  ),
                            trailing:
                                Text(art.author == null ? '' : art.author),
                            title: Text(art.title == null ? '' : art.title),
                            onTap: () {
                              //Navigator.push(context, new MaterialPageRoute(builder: (context) => new Home()));
                            },
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<Article>> fetchArticles(String searchTerm) async {
  // if no search term, show headlines!

  final response = searchTerm == ''
      ? await http.get(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=72d027b1dc974964b9af07784ff0636d')
      : await http.get('https://newsapi.org/v2/everything?q=' +
          searchTerm +
          '&apiKey=72d027b1dc974964b9af07784ff0636d');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    //print(json.decode(response.body)['articles'][1]);

    final arts = <Article>[];

    final jResponse = json.decode(response.body);
    final numArticles =
        jResponse['totalResults'] < 20 ? jResponse['totalResults'] : 20;

    for (var i = 0; i < numArticles; i++) {
      arts.add(Article.fromJson(jResponse['articles'][i]));
    }

    //print(numArticles);

    return arts;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load articles');
  }
}

class Article {
  final String title;
  final String author;
  final String content;
  final String urlToImage;

  Article({this.title, this.author, this.content, this.urlToImage});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        title: json['title'],
        author: json['author'],
        content: json['content'],
        urlToImage: json['urlToImage']);
  }
}
