import 'package:flutter/material.dart';
import 'package:gear_zone/component/custom_appbar.dart'; // Đường dẫn tới file custom_appbar.dart

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  double _appBarOpacity = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          // Khi cuộn 100px, opacity đạt 1 (có thể điều chỉnh ngưỡng theo ý)
          _appBarOpacity = (_scrollController.offset / 100).clamp(0.0, 0.8);
        });
      });
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          // Nội dung chính cuộn được
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 700,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'assets/images/banner_appbar5.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    title: Text('Item $index'),
                  ),
                  childCount: 30,
                ),
              ),
            ],
          ),
          // Overlay AppBar tùy chỉnh với hiệu ứng opacity
          CustomAppBar(
            opacity: _appBarOpacity,
            scaffoldKey: _scaffoldKey,
          ),
        ],
      ),
    );
  }
}
