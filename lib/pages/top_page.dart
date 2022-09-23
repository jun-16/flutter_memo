
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
  final memoCollection = FirebaseFirestore.instance.collection('memo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter × Firebase'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: memoCollection.snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if(!snapshot.hasData) {
            return const Center(child: Text('データがありません'));
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
              final Memo fetchMemo = Memo(
                title: data['title'],
                detail: data['detail'],
                createdDate: data['createdDate'],
                updatedDate: data['updatedDate'],
              );
              return ListTile(
                title: Text(fetchMemo.title),
                onTap: () {
                  //確認画面に遷移する記述を書く
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MemoDetailPage(fetchMemo)));
                },
              );
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMemoPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}