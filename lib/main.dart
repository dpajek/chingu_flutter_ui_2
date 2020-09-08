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
      title: 'Flutter Demo - Tier 2',
      theme: ThemeData(
        // This is the theme of your application.
        //
        //cardColor: Colors.blueGrey,
        cardTheme: CardTheme(
          color: Colors.blueGrey,
          shadowColor: Colors.redAccent,
          elevation: 4,
        ),

        focusColor: Colors.redAccent,

        appBarTheme: AppBarTheme(
          color: Colors.blueGrey,
          shadowColor: Colors.redAccent,
          //elevation: 2
        ),

        buttonColor: Colors.red[300],

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Dashboard'),
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
  Future<List<Article>> futureArticles;

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
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Search bar
            Container(
              constraints: BoxConstraints(maxWidth: 400), //max width on search
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              height: 30,
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
            ), // Search bar end

            // Article Cards Row
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildArticlesTitleRow(context),

                //_buildFutureList(futureArticles),
                _buildFutureCards(futureArticles),
              ],
            ),

            //_buildArticleOfTheDayTitleRow(context),

            //_buildFutureArticleOfTheDay(futureArticles),

          ],
        ),
      ),
    );
  }
}

Widget _buildArticlesTitleRow(context) => Container(
                  constraints:
                      BoxConstraints(maxWidth: 600), //max width on card titles
                  padding: EdgeInsets.fromLTRB(10, 20, 10,
                      0), //changed to top=20 after making scrollable
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Articles',
                        //textAlign: TextAlign.left,
                      ),
                      FlatButton(
                        //color: Colors.blue,
                        textColor: Theme.of(context).buttonColor,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(0),
                        splashColor: Colors.blueAccent,
                        onPressed: /*_pushAllArticles*/ () {},
                        child: Text(
                          "All Articles",
                        ),
                      )
                    ],
                  ),
                );

Widget _buildFutureCards(Future<List<Article>> futureArticles) =>
    FutureBuilder<List<Article>>(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            (snapshot.connectionState == ConnectionState.done)) {
          List<Article> arts = snapshot.data;

          return Container(
            height: 180,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: arts.length,
                itemBuilder: (context, index) {
                  Article art = arts[index];

                  return _buildArticleCard(art);
                }),
          );
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
    );

// Card Widget
Widget _buildArticleCard(Article art) => Container(
      //Expanded(
      //child: SizedBox(
      //height: 180,
      width: 160,
      child: InkWell(
        onTap: () {
          /*
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(art.title),
                    ),
                    body: _buildDetailsPage(art),
                  );
                },
              ),
            );
            */
        },
        child: Card(
          // This ensures that the Card's children (including the ink splash) are clipped correctly.
          clipBehavior: Clip.antiAlias,
          //color: Colors.blueGrey,
          //shape: null,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: art.urlToImage == null
                    ? Icon(Icons.error_outline, size: 75)
                    : Image(
                        image: NetworkImage(art.urlToImage),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                      ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                alignment: Alignment.centerLeft,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      art.title == null
                          ? 'no title'
                          : (art.title.length > 40
                              ? art.title.substring(0, 40)
                              : art.title),
                      style: TextStyle(fontSize: 13.0, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      art.author == null
                          ? 'no author'
                          : (art.author.length > 40
                              ? art.author.substring(0, 40)
                              : art.author),
                      style: TextStyle(fontSize: 11.0, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

// Keep this for future reference
/*
Widget _buildFutureList(Future<List<Article>> futureArticles) => Expanded(
      child: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              (snapshot.connectionState == ConnectionState.done)) {
            List<Article> arts = snapshot.data;

            return ListView.builder(
                itemCount: arts.length,
                itemBuilder: (context, index) {
                  Article art = arts[index];

                  return Container(
                    height: 60,
                    child: ListTile(
                      leading: art.urlToImage == null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(art.urlToImage),
                            ),
                      trailing: Text(art.author == null ? '' : art.author),
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
    );
    */

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
