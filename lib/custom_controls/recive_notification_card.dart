import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/custom_ad.dart';
import 'package:sampleflutter/utils/convert_utc_to_local.dart';



class ReciveNotificationCard extends StatefulWidget {
  final String notificationTitle;
  final String notificationBody;
  final String? notificationImageUrl;
  final String notificationCreatedAtUtc;
  final String notificationCreatedBy;
  const ReciveNotificationCard(
    {
      super.key,
      required this.notificationTitle,
      required this.notificationBody,
      this.notificationImageUrl="",
      required this.notificationCreatedAtUtc,
      required this.notificationCreatedBy
    }
  );

  @override
  State<ReciveNotificationCard> createState() => _ReciveNotificationCardState();
}

class _ReciveNotificationCardState extends State<ReciveNotificationCard> {
  int _reloadToken = 0;

  void _reloadImage() {
    setState(() {
      _reloadToken=0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade500,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.orange,
                blurStyle: BlurStyle.outer,
                blurRadius: 3,
                spreadRadius: 1
              )
            ]
          ),

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      formatUtcToLocal(widget.notificationCreatedAtUtc),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 12
                      ),
                    ),
                  
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "by : ${widget.notificationCreatedBy}",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 12
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.notificationTitle},",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 15
                            ),
                            softWrap: true,
                          ),
                          SizedBox(height: 5,),
                          Text(
                            widget.notificationBody,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 13
                            ),
                            softWrap: true,
                          )
                        ],
                      ),
                    ),
                    if (widget.notificationImageUrl!=null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ImageShowerDialog(
                                imageUrl: widget.notificationImageUrl!,
                              ),
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:widget.notificationImageUrl!,
                            width: 100,
                            height: 100,
                            placeholder: (context, url)  {
                              return SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(color: Colors.white,),
                                  ),
                                );
                            },
                            errorWidget: (context, error, stackTrace) {
                              return Column(
                                children: [
                                  SvgPicture.asset("assets/svg/file-broken-svgrepo-com.svg",width: 50,height: 10,),
                                  Text("Image Error retry",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                                  IconButton(
                                    icon: const Icon(Icons.refresh, color: Colors.white),
                                    onPressed: _reloadImage,
                                  )
                                ],
                              );
                            },
                          )
                        ),
                      )
                  ],
                ),

                
              ],
            ),
          ),
        ),
      );
  }
}