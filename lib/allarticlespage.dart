import 'package:chingu_flutter_ui_2/detailspage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chingu_flutter_ui_2/datadefinition.dart';
import 'package:chingu_flutter_ui_2/platformwidgets.dart';


class AllArticlesPage extends StatelessWidget {
  AllArticlesPage({Key key, @required this.futureArticles}) : super(key: key);

  final Future<List<Article>> futureArticles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Articles"),
      ),
      body: FutureBuilder(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              (snapshot.connectionState == ConnectionState.done)) {
            List<Article> articles = snapshot.data;

            return _buildAllArticlesPage(articles);
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
      ),
    );
  }


  Widget _buildAllArticlesPage(List<Article> articles) {
    return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: articles.length,
        itemBuilder: (context, i) {
          //if (i.isOdd) return Divider(); /*2*/

          //final index = i ~/ 2; /*3*/
          return _buildRow(articles[i], context);
        });
  }

  Widget _buildRow(Article article, context) {
    return Container(
      height: 60,
      child: ListTile(
        title: Text(
          article.title == null ? 'no title' : article.title,
          //style: _biggerFont,
        ),
        leading: article.urlToImage == null
            ? CircleAvatar(
                backgroundColor: Colors.grey,
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(article.urlToImage),
                radius: 20,
              ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(title: 
                    Text(
                      article.title == null
                          ? 'no title'
                          : (article.title.length > 25
                              ? (article.title.substring(0, 25) + '...')
                              : article.title),
                    ),
                  ),
                  body: DetailsPage(
                    article: article,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
