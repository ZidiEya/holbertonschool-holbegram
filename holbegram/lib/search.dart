import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(238, 238, 238, 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    
                  },
                ),
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No Post Found'));
          }

          var documents = snapshot.data!.docs;

          return StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              return StaggeredTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: index.isEven ? 2 : 3,
                child: Image.network(
                  documents[index]['postUrl'],
                  fit: BoxFit.cover,
                ),
              );
            },
            staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
          );
        },
      ),
    );
  }
}
