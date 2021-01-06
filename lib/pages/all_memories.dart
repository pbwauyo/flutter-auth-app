import 'package:auth_app/models/memory.dart';
import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_progress_indicator.dart';
import 'package:auth_app/widgets/empty_results_text.dart';
import 'package:auth_app/widgets/error_text.dart';
import 'package:auth_app/widgets/memory_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AllMemories extends StatelessWidget {
  final String momentId;
  final _memoryRepo = MemoryRepo();

  AllMemories({this.momentId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: SvgPicture.asset(AssetNames.APP_LOGO_SVG, width: 100, height: 35,),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _memoryRepo.getMomentMemoriesAsStream(momentId: momentId),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final docs = snapshot.data.docs;

            if(docs.length <= 0){
              return Center(
                child: EmptyResultsText(message: "No memories yet",),
              );
            }

            final memoriesList = docs.map((doc) => Memory.fromMap(doc.data())).toList();

            return ListView.builder(
              itemCount: memoriesList.length,
              itemBuilder: (context, index){
                return Center(
                  child: Container(
                    width: screenWidth * 0.8,
                    margin: const EdgeInsets.only(top: 8),
                    child: MemoryWidget(
                      width: double.infinity,
                      height: 180,
                      memory: memoriesList[index]
                    ),
                  ),
                );
              }
            );
          }
          else if(snapshot.hasError){
            return Center(
              child: ErrorText(error: "${snapshot.error}"),
            );
          }
          return Center(
            child: CustomProgressIndicator(),
          );
        }
      ),
    );
  }
}