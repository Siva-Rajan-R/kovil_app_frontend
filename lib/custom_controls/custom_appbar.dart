import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KovilAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final double height;
  final double titleSize;
  final List<Widget>? actions;
  final bool withIcon;

  const KovilAppBar(
    {
      this.title="Nanmai Tharuvar Kovil",
      this.height=120,
      this.titleSize=25,
      this.withIcon=false,
      this.actions,
      super.key
    }
  );
  @override
  Size get preferredSize => Size.fromHeight(height);
  
  @override
  
  Widget build(BuildContext context) {
    final List<Widget> titleWidget=[
      SvgPicture.asset(
          "assets/svg/temple-india-svgrepo-com.svg",
          width: 40,
          height: 40,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleSize,
            color: Colors.white,
            overflow: TextOverflow.ellipsis
          ),
        )
    ];
    final List<Widget> appBarTitle;
    if(withIcon){
      appBarTitle=titleWidget;
    }
    else{
      appBarTitle=[titleWidget.last];
    }

    return PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade400,
                Colors.orange.shade700,
                Colors.orange.shade800
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(20, 20),bottomRight: Radius.elliptical(20, 20))
          ),
          child: AppBar(
              actions: actions,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              toolbarHeight: height,
              title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.from(appBarTitle),
            )
          ),
        ),
      );
  }

}