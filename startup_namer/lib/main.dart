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

  final _saved = new Set<String>(); //存储用户收藏的单词对

  //在这个状态的build中构建Scaffold，body调用_buildSuggestion方法。
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        //这里是在appBar添加一个列表图标。点击时调用pushSaved方法来跳转到新的页面。
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: pushSaved),
        ],
      ),
      body: _buildSuggestion(),
    );
  }

  Widget _buildSuggestion() {
    //这个builder是一个构造器，用于生成ListView。
    //适合用于有很多很多列的列表，只有可以被看见的列会调用这个方法
    //也就是一列一列的生成，注意里面的itemBuilder
    //里面存放单词对
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
          //print(index);
          return _buildRow(_suggestions[index].asPascalCase); //这个方法用于生成有单词对的一行。
        });
  }

//这个方法得到一个单词对，生成一个包含它的ListTile widget返回。
  Widget _buildRow(String word) {
    final alreadySaved = _saved.contains(word); //标记这个单词是否已经被收藏
    return new ListTile(
        title: new Text(
          word,
          style: _biggerFont,
        ),
        //trailing是列表的每一行末尾
        trailing: new Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null),
        onTap: () {
          setState(() {
            //这个方法调用的时候会调用build方法重新渲染widget更新视图（改变心心）
            if (alreadySaved) {
              _saved.remove(word);
            } else {
              _saved.add(word);
            }
          });
        });
  }

//当用户点击导航栏中的列表图标时，建立一个路由并将其推入到导航管理器栈中。
  void pushSaved() {
    Navigator.of(context).push(
      //路由入栈？
      //新页面的内容在MaterialPageRoute的builder属性中构建，builder是一个匿名函数
      MaterialPageRoute<void>(
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            final tiles = _saved.map(
              (word) {
                //给用户收藏的单词创建列表
                return new ListTile(
                    title: new Text(
                      word,
                      style: _biggerFont,
                    ),
                    trailing: new Icon(Icons.delete),
                    onTap: () {
                      setState(() {
                        _saved.remove(word);
                      });
                      this.setState(() {});
                    });
              },
            );
            final divided = ListTile.divideTiles(
              //这个方法在每个ListTile之间增加1像素的分割线。（为什么之前那个页面不用？）
              context: context,
              tiles: tiles,
            ).toList();
            //方法返回一个Iterable，用toList()方法把它变成List。divided持有最终的列表项

            return new Scaffold(
              appBar: new AppBar(
                title: new Text('Saved Suggestions'),
              ),
              body: new ListView(children: divided),
            );
          });
        },
      ),
    );
  }
}
