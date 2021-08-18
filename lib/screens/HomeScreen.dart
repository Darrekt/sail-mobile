import 'package:flutter/material.dart';
import 'package:spark/components/home/PartnerStatusHero.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _deviceDimensions = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          floating: true,
          backgroundColor: Colors.transparent,
          expandedHeight: _deviceDimensions.height * 0.3,
          // expandedHeight: _deviceDimensions.height - kBottomNavigationBarHeight,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              // TODO: Replace placeholder image with user-chosen one
              "https://i.pinimg.com/originals/cb/e5/22/cbe522e7e41945d8744e7ad2b84465f5.jpg",
              fit: BoxFit.fill,
            ),
          ),
        ),
        SliverSafeArea(
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return PartnerStatusHero();
          }, childCount: 6)),
        )
        // ListView(
        //   children: <Widget>,
        // )
      ],
    );
  }
}
