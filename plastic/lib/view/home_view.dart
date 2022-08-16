import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plastic/model/sample_model.dart';
import 'package:plastic/service/database_service.dart';
import 'package:plastic/view/sample_review.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    Provider.of<DatabaseService>(context,listen: false).getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<SampleModel>>(
          future: Provider.of<DatabaseService>(context,listen: false).getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text('${snapshot.data![index].title}'),
                    subtitle: Text('${snapshot.data![index].typ}'),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            image: FileImage(File('${snapshot.data![index].files}')),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    trailing: Text(snapshot.data![index].datetime!.split('T')[0]),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SampleReview(
                          SampleModel(
                            title: '${snapshot.data![index].title}',
                            subtitle: '${snapshot.data![index].subtitle}',
                            files: snapshot.data![index].files,
                            lat: snapshot.data![index].lat,
                            lng: snapshot.data![index].lng,
                            datetime: snapshot.data![index].datetime,
                            typ: '${snapshot.data![index].typ}'
                          )
                      )));
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        )
      ),
    );
  }
}





