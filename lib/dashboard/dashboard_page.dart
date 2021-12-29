import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/authorization/pages/authorization_page.dart';
import 'package:property_management/home/pages/list_objects_page.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/widgets/box_icon.dart';


class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController textController = new TextEditingController();

  int currentIndex = 0;

  final List<Widget> pages = [
    ListObjectsPage(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: IndexedStack(
              key: const PageStorageKey('Indexed'),
              index: currentIndex,
              children: pages,
            ),
      ),
      bottomNavigationBar: MyNavBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          {
            'iconPath': 'assets/icons/home.svg',
            'title': 'Объекты',
          },
          {
            'iconPath': 'assets/icons/characteristic.svg',
            'title': 'Характеристики',
          },
          {
            'iconPath': 'assets/icons/exploitation.svg',
            'title': 'Эксплуатация',
          },
          {
            'iconPath': 'assets/icons/analytics.svg',
            'title': 'Аналитика',
          },
          {
            'iconPath': 'assets/icons/total.svg',
            'title': 'Итоги',
          },
        ],
      ),
    );
  }
}

class MyNavBar extends StatelessWidget{
  final List<Map> items;
  final int currentIndex;
  final Function(int) onTap;

  MyNavBar({Key? key, required this.items, required this.currentIndex,
    required this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffFCFCFC).withOpacity(0.83),
                Color(0xffFCFCFC),
              ]
          )
        ),
        padding: EdgeInsets.only(
            left: 25.sp,
            right: 25.sp
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) =>
              InkWell(
                onTap: (){
                  onTap(index);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoxIcon(
                      iconPath: items[index]['iconPath'],
                      iconColor: index == currentIndex ? Colors.white : Colors.black,
                      backgroundColor: Colors.white,
                      gradient: index == currentIndex
                          ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff6395F9),
                                  Color(0xff0940CD),
                                ]
                            )
                          : null,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      items[index]['title'],
                      style: caption2,
                    )
                  ],
                ),
              ),
          ),
        )
    );
  }

}

ListTile buildListTile(
    BuildContext context, IconData icon, String title, Widget onPress) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    onTap: () {
      if(icon == Icons.supervised_user_circle_rounded)
        Navigator.pop(context);
      // Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => onPress));
    },
    leading: Icon(
      icon,
      size: 22,
      color: Theme.of(context).primaryColor,
    ),
    title: Text(
      title,
      style: TextStyle(letterSpacing: 2).copyWith(fontSize: 16),
    ),
  );
}
