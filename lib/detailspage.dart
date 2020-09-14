import 'package:flutter/material.dart';
import 'package:chingu_flutter_ui_2/datadefinition.dart';
import 'package:flutter/foundation.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key key, @required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: const Alignment(-1, 0.8),
            children: [
              SizedBox(
                height: 300,
                //width: 150,
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
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                //alignment: Alignment.bottomLeft,
                color: Colors.grey[200].withOpacity(0.7),

                child: Text(
                  article.author == null
                      ? 'no author'
                      : (article.author.length > 40
                          ? article.author.substring(0, 40)
                          : article.author),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
                child: Text(
                  article.content == null ? 'no content' : article.content,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
