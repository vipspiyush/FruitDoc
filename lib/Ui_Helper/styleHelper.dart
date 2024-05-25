import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colorHelper.dart';
import 'colorHelper.dart';
import 'colorHelper.dart';

//buttonStyle for everywhere

ButtonStyle elevatedButtonStyle({bgColor=const Color(0xff92C7CF),
  fgColor=Colors.white,double radius=6.0}){
  return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      )
  );
}

//text design

Text styleText({required String text,double size=20.0,txtColor=Colors.white,FontWeight weight=FontWeight.normal}){
  return Text(text,style: GoogleFonts.poppins(fontSize: size,color: txtColor,fontWeight: weight),);
}

//appBar

AppBar customAppBar({required String text,double size=20,
  FontWeight weight=FontWeight.normal,double elevation=0,bgColor=const Color(0xff92C7CF),txtColor=Colors.white}){
  return AppBar(
    elevation: elevation,
    backgroundColor: bgColor,
    centerTitle: true,
    title: Text(text,style: GoogleFonts.poppins(fontSize: size,fontWeight: weight,color: txtColor),),
  );
}

//textField

InputDecoration fieldDecoration({String hintText="Hello",double radius=10.0,double width=0.0,borderColor=Colors.black}){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey.shade500),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          width: width,
          color: borderColor,
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          width: 2,
          color: lightGreen,
        )
    ),
  );
}

//mediaQuery height and width

Widget height({context,required double value}){
  double height=MediaQuery.of(context).size.height;
  return SizedBox(height: height*value,);
}

Widget width({context,required double value}){
  double width=MediaQuery.of(context).size.width;
  return SizedBox(height: width*value,);
}

//small dot sized containers

Widget dot({context,dotColor=Colors.lightGreen}){
  return Container(
    height:MediaQuery.of(context).size.height*0.03,
    width:MediaQuery.of(context).size.width*0.03,
    decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle
    ),
  );
}

//custom container for indicating the status of uploaded file

Widget status({context,Color pickedColor=Colors.white}){
  return Container(
    height: MediaQuery.sizeOf(context).height*0.04,
    width: MediaQuery.sizeOf(context).width*0.04,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pickedColor
    ),
  );
}
