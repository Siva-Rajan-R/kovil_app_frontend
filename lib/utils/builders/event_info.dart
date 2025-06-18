import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/utils/enums.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/open_phone.dart';

Widget buildEventInfo(Map eventDetails, BuildContext context) {
  print("event $eventDetails['paid_amount']");
  final List<String> eventStartAt = eventDetails["event_start_at"].split(":");
  final List<String> eventEndAt = eventDetails["event_end_at"].split(":");
  final int paid = eventDetails['paid_amount'] ?? 0;
  final int total = eventDetails['total_amount'] ?? 0;
  final int profitOrLoss = paid - total;
  final String eventDescription =
      eventDetails['neivethiyam_name'] != null
          ? "${eventDetails['neivethiyam_name']}-${eventDetails['padi_kg']} Padi/Kg\n${eventDetails['event_description']}"
          : eventDetails['event_description'] ?? "";

  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade400,
                Colors.orange.shade600,
                Colors.orange.shade800,
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade800,
                blurRadius: 5,
                spreadRadius: 2,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Event Info",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/date-svgrepo-com.svg",
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        eventDetails["event_date"],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/alarm-clock-svgrepo-com.svg",
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${eventStartAt[0]}:${eventStartAt[1]}-${eventEndAt[0]}:${eventEndAt[1]}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset("assets/svg/event svy.svg", width: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      eventDetails["event_name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/information-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      eventDescription,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade400,
                Colors.orange.shade600,
                Colors.orange.shade800,
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade800,
                blurRadius: 5,
                spreadRadius: 2,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Client Info",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/user-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      eventDetails["client_name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/mobile-phone-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => makePhoneCall(
                            eventDetails["client_mobile_number"],
                            context,
                          ),
                      child: Text(
                        eventDetails["client_mobile_number"],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/map-map-marker-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      eventDetails["client_city"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade400,
                Colors.orange.shade600,
                Colors.orange.shade800,
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade800,
                blurRadius: 5,
                spreadRadius: 2,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Payment Info",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/money-cash-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    currentUserRole == UserRoleEnum.ADMIN.name
                        ? "${eventDetails['payment_status']} ($paid ₹)"
                        : eventDetails["payment_status"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/payment-method-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    eventDetails["payment_mode"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/money-bag-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    currentUserRole == UserRoleEnum.ADMIN.name
                        ? "Total Amount ($total ₹)"
                        : "-----",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/graph-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    currentUserRole == UserRoleEnum.ADMIN.name
                        ? profitOrLoss >= 0
                            ? "Profit ($profitOrLoss ₹)"
                            : "Loss ($profitOrLoss ₹)"
                        : "-----",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    ),
  );
}
