//Data Definition

class Article {
  final String title;
  final String author;
  final String content;
  final String urlToImage;
  final String url;

  Article({this.title, this.author, this.content, this.urlToImage, this.url});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        title: json['title'],
        author: json['author'],
        content: json['content'],
        urlToImage: json['urlToImage'],
        url: json['url']);
  }
}
