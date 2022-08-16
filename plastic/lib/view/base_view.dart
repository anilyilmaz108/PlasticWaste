import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plastic/extensions/locale_keys.dart';
import 'package:plastic/service/auth_service.dart';
import 'package:plastic/view/get_sample_view.dart';
import 'package:plastic/view/home_view.dart';
import 'package:plastic/view/language_selected_view.dart';
import 'package:plastic/view/location_view.dart';
import 'package:provider/provider.dart';

class BaseView extends StatefulWidget {
  const BaseView({Key? key}) : super(key: key);

  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView>{
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    LocationView(),
    GetSampleView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> appbarTitleList = [
    LocaleKeys.base_view_title_1.tr(),LocaleKeys.base_view_title_2.tr(),LocaleKeys.base_view_title_3.tr()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: LocaleKeys.base_view_title_1.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            label: LocaleKeys.base_view_title_2.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_saver_off,),
            label: LocaleKeys.base_view_title_3.tr(),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.black26,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  PreferredSizeWidget _buildAppBar(int index) {
    return AppBar(
      title: Text(
        appbarTitleList[index],
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            onPressed: (){
              Provider.of<AuthService>(context, listen: false).SignOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LanguageSelectedView(

                )),
                    (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: Colors.black26,)
        ),
      ],
    );
  }
}



