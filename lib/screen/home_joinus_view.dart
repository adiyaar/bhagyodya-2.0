import 'package:bhagyoday/screen/Contact_Us.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bhagyoday/shared/colors.dart';
import 'package:bhagyoday/utils/app_colors.dart';
import 'package:bhagyoday/utils/ui_helper.dart';
import 'package:bhagyoday/widgets/dotted_seperator_view.dart';
import 'package:bhagyoday/utils/ui_helper.dart';

class joinusview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Join Us', style:  GoogleFonts.montserrat(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                    UIHelper.verticalSpaceSmall(),
                    Text(
                      'Empowering people to live in harmony with nature in urban metros using'
                          ' alternative traditional ways and means for holistic health healing and wellness.'

                          ,
                      style: GoogleFonts.montserrat(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    DottedSeperatorView(),
                    SizedBox(height: 20.0,),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Column(
                          children: <Widget>[
                            Card(
                              elevation: 0,
                              shape: BeveledRectangleBorder(
                                side: BorderSide(
                                  color:AppColors.separatorGrey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(3.0),

                              ),
                              child: ListTile(
                                leading: Icon(MaterialCommunityIcons.message_processing,color:Colors.green),
                                title: Text('Still need help? Email us.',style: TextStyle(
                                    fontWeight: FontWeight.w600
                                ),),
                                trailing: Icon(Icons.arrow_right),
                                onTap: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => Contact_Us()));},
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: BeveledRectangleBorder(
                                side: BorderSide(
                                  color:AppColors.separatorGrey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(3.0),

                              ),

                            ),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),



              UIHelper.horizontalSpaceMedium(),

            ],
          ),
          UIHelper.verticalSpaceMedium(),


        ],
      ),
    );
  }
}

class _GenieCardView extends StatelessWidget {
  const _GenieCardView({
    Key key,
    @required this.title,
    @required this.desc,
    @required this.image,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String desc;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 2.0,
                offset: Offset(1.0, 3.0),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 22.0),
              ),
              UIHelper.verticalSpaceMedium(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        desc,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      UIHelper.verticalSpaceSmall(),
                      ClipOval(
                        child: Container(
                          alignment: Alignment.center,
                          color: swiggyOrange,
                          height: 25.0,
                          width: 25.0,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      UIHelper.verticalSpaceMedium(),
                    ],
                  ),
                  UIHelper.horizontalSpaceMedium(),
                  Flexible(
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                    ),
                  ),
                  UIHelper.horizontalSpaceExtraSmall(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
