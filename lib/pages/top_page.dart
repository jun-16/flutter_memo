
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memo/model/memo.dart';
import 'package:flutter_memo/pages/add_memo_page.dart';
import 'package:flutter_memo/pages/memo_detail_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});

  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<Memo> memoList = [];

  Future<void> fetchMemo() async{
    final memoCollection = await FirebaseFirestore.instance.collection('memo').get();
    final docs = memoCollection.docs;
    print('データ');
    print(memoCollection);
    print(docs);
    for(var doc in docs) {
      Memo fetchMemo = Memo(
        title: doc.data()['title'],
        detail: doc.data()['detail'],
        createdDate: doc.data()['createdDate']
        // title: 'title',
        // detail: 'detail',
        // createdDate: Timestamp.now()
      );
      memoList.add(fetchMemo);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchMemo();
  }

  @override
  Widget build(BuildContext context) {
    print('memoList：');
    print(memoList);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter × Firebase'),
      ),
      body: ListView.builder(
        itemCount: memoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(memoList[index].title),
            onTap: () {
              //確認画面に遷移する記述を書く
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => MemoDetailPage(memoList[index])));
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddMemoPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}