import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/semantics.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  //无状态的widget
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RandomWordsState();
  //这是一个有状态的widget。这个widget仅仅重写这个创建状态的方法创建一个state。
  //这个状态类写在后面。
}

class RandomWordsState extends State<RandomWords> {
  //这是一个状态类

  final _suggestions = <WordPair>[]; //一个单词对的数组：建议列表，用于存储生成的单词对
  final _biggerFont = const TextStyle(fontSize: 18.0); //这个变量用于设置字体大小

  //在这个状态的build中构建Scaffold，body调用_buildSuggestion方法。
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
      ),
      body: _buildSuggestion(),
    );
  }

  Widget _buildSuggestion() {
    //这个方法用于生成ListView，里面存放单词对
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0), //这个是设置内边距！！
        itemBuilder: (context, i) {
          //这两个参数，i是指第i行，但是context是什么呢？？？

          //如果是奇数行，直接返回一个Divider（分割线widget）
          if (i.isOdd) return new Divider();

          //如果显示完了，要继续生成新单词对。
          final index = i ~/ 2; //【~/】返回整数值的除法！
          //为什么除2？因为要减去分割线所在的行，再和单词对的数量比较。
          if (index >= _suggestions.length) {
            //继续生成
            _suggestions.addAll(generateWordPairs().take(10));
          }
          //如果是非奇数行：生成单词对的widget
          print(index);
          return _buildRow(_suggestions[index].asPascalCase); //这个方法用于生成有单词对的一行。
        });
  }

//这个方法得到一个单词对，生成一个包含它的ListTile widget返回。
  Widget _buildRow(String word) {
    return new ListTile(
      title: new Text(
        word,
        style: _biggerFont,
      ),
    );
  }
}
