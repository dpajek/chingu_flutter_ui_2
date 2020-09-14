import 'package:chingu_flutter_ui_2/detailspage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:chingu_flutter_ui_2/datadefinition.dart';


class ArticleOfTheDay extends StatelessWidget {
  ArticleOfTheDay({Key key, @required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _buildBackBox(10, 170, Colors.blueGrey[100]),
        _buildBackBox(5, 165, Colors.blueGrey[200]),
        SizedBox(
          height: 160,
          //width: 150,
          child: InkWell(
            onTap: () {
              //onPressed: () { // if CupertinoButton is used
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
                        ));
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
                    child: article.urlToImage == null
                        ? Icon(Icons.error_outline, size: 75)
                        : Image(
                            image: NetworkImage(article.urlToImage),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                          ),
                  ),
                  Container(
                    //color: Colors.blueGrey,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title == null
                              ? 'no title'
                              : (article.title.length > 25
                                  ? (article.title.substring(0, 25) + '...')
                                  : article.title),
                          style: TextStyle(fontSize: 13.0, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Icon(
                                Icons.bookmark,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Icon(
                                Icons.reply,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackBox(double boxPadding, double boxHeight, Color boxColour) =>
      Container(
        padding: EdgeInsets.fromLTRB(boxPadding, 0, boxPadding, 0),
        child: SizedBox(
          height: boxHeight,
          //width: 150,
          child: Card(
            // This ensures that the Card's children (including the ink splash) are clipped correctly.
            clipBehavior: Clip.antiAlias,
            color: boxColour,
            child: Container(),
          ),
        ),
      );
}
