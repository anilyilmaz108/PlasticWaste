import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plastic/constants.dart';
import 'package:plastic/view/beginning.dart';

class LanguageSelectedView extends StatefulWidget {

  @override
  State<LanguageSelectedView> createState() => _LanguageSelectedViewState();
}

class _LanguageSelectedViewState extends State<LanguageSelectedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 550,
        width: 550,
        child: IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: AlertDialog(
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      context.setLocale(AppConstant.ES_LOCALE);
                                    });

                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.language),
                                      Text("es-ES"),
                                    ],
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      context.setLocale(AppConstant.EN_LOCALE);
                                    });

                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.language),
                                      Text("EN-US"),
                                    ],
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      context.setLocale(AppConstant.TR_LOCALE);
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.language),
                                      Text("TR"),
                                    ],
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      context.setLocale(AppConstant.DE_LOCALE);
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.language),
                                      Text("DE"),
                                    ],
                                  )),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => Beginning()));
                              },
                              child: Text("Ok"))
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}