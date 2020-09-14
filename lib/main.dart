import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // used for http requests
import 'dart:convert'; // provides the json converter
import 'dart:math';

import 'package:chingu_flutter_ui_2/datadefinition.dart';
import 'package:chingu_flutter_ui_2/detailspage.dart';
import 'package:chingu_flutter_ui_2/allarticlespage.dart';
import 'package:chingu_flutter_ui_2/articleoftheday.dart';
import 'package:chingu_flutter_ui_2/platformwidgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo - Tier 2',
      theme: ThemeData.light().copyWith(
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
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Search bar
              Container(
                constraints:
                    BoxConstraints(maxWidth: 400), //max width on search
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
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
                  _buildArticlesTitleRow(context, futureArticles),
                  _buildFutureCards(futureArticles),
                ],
              ),

              // Article of Day
              Container(
                constraints: BoxConstraints(
                    maxWidth:
                        400), // more responsive -- don't let expand too far on wider screens
                padding: EdgeInsets.fromLTRB(
                    0, 20, 10, 0), // changed to top=20 after making scrollable
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child: Text(
                        'Article of the Day',
                      ),
                    ),
                    _buildFutureArticleOfDay(futureArticles),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFutureArticleOfDay(Future<List<Article>> futureArticles) =>
    FutureBuilder<List<Article>>(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            (snapshot.connectionState == ConnectionState.done)) {
          List<Article> articles = snapshot.data;

          if (articles.length < 1) return Container();

          Random random = new Random();
          var randomIndex = random.nextInt(articles.length);

          print('Random number: $randomIndex');

          return ArticleOfTheDay(article: articles[randomIndex]);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: ActivityIndicator(),
          ),
        );
      },
    );

Widget _buildArticlesTitleRow(context, Future<List<Article>> futureArticles) =>
    Container(
      constraints: BoxConstraints(maxWidth: 600), //max width on card titles
      padding: EdgeInsets.fromLTRB(
          10, 20, 10, 0), //changed to top=20 after making scrollable
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
            onPressed: () {
              _pushAllArticles(context, futureArticles);
            },
            child: Text(
              "All Articles",
            ),
          )
        ],
      ),
    );

void _pushAllArticles(context, Future<List<Article>> futureArticles) {
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return AllArticlesPage(futureArticles: futureArticles);
    },
  ));
}

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

                  return _buildArticleCard(art, context);
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
            child: ActivityIndicator(),
          ),
        );
      },
    );

// Card Widget
Widget _buildArticleCard(Article art, context) => Container(
      width: 160,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      art.title == null
                          ? 'no title'
                          : (art.title.length > 25
                              ? (art.title.substring(0, 25) + '...')
                              : art.title),
                    ),
                  ),
                  body: DetailsPage(
                    article: art,
                  ),
                );
              },
            ),
          );
        },
        child: Card(
          // This ensures that the Card's children (including the ink splash) are clipped correctly.
          clipBehavior: Clip.antiAlias,
          //color: Colors.blueGrey,
          //shadowColor: Colors.redAccent,
          //elevation: 4,
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

    return arts;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load articles');
  }
}
