import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reuseable_componets/modules/news_app/web_view/web_view_screen.dart';
import 'package:reuseable_componets/modules/shop_app/login/shop_login_screen.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/cubit.dart';
import 'package:reuseable_componets/shared/cubit/cubit.dart';
import 'package:reuseable_componets/shared/network/local/cache_helper.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
  double radius = 0.0,
  @required Function function,
  @required String text,
  bool isUppercase = true,
}) =>
    Container(
      width: width,
      height: 60.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUppercase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
    );

Widget defaultTextButton({
  @required Function function,
  @required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(text.toUpperCase()),
    );

  Widget  defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onTap,
  Function onChange,
  @required Function validate,
  @required String label,
  @required String hint,
  @required IconData prefix,
  IconData suffix,
  bool isPassword = false,
  Function suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      keyboardType: type,
      obscureText: isPassword,
      validator: validate,
      onTap: onTap,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
              : null,
          border: OutlineInputBorder()),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']} '),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${model['title']}",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text("${model['date']}",
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                ],
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            IconButton(
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'done', id: model['id']);
                }),
            SizedBox(
              width: 10.0,
            ),
            IconButton(
                icon: Icon(
                  Icons.archive_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'archive', id: model['id']);
                }),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: model['id']);
      },
    );

Widget buildArticleItem(article, context) => InkWell(
      onTap: () {
        navigateTo(context, WebViewScreen(article['url']));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage('${article['urlToImage']}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Container(
                height: 120.0,
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        '${article['title']}',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );

   void showToast({@required String text, @required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);
   enum ToastStates {SUCCESS,ERROR ,WARNING}

   Color chooseToastColor(ToastStates state){
     Color color ;
switch (state){
  case ToastStates.SUCCESS:
   color=  Colors.green ;
    break;
  case ToastStates.ERROR:
    color=  Colors.red ;
    break;
  case ToastStates.WARNING:
    color =  Colors.amber ;
    break;
}
return color;
}
void signOut (context){
  CacheHelper.removeData(key: 'token').then((value) {
    if (value){
      navigateAndFinish(context,ShopLoginScreen());
    }

  });
}
Widget buildListProduct ( model,context,{bool isOldPrice = true})=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height:200.0,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image),
              width: 200.0,
              height: 200.0,
            ),
            if(model.discount != 0 && isOldPrice)
              Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  'DISCOUNT',style: TextStyle(
                  color:Colors.white,
                  fontSize: 10.0,
                ),
                ),
              )
          ],
        ),
        SizedBox(width:20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1.3),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    model.price.toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  if(model.discount!=0&& isOldPrice)
                    Text(
                      model.oldPrice.toString(),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Spacer(),
                  IconButton(
                      icon: CircleAvatar(
                        backgroundColor:ShopCubit.get(context).favorites[model.id]
                            ?Colors.deepOrange: Colors.grey,
                        radius: 15.0,
                        child: Icon(Icons.favorite_outline,
                          color: Colors.white,
                          size: 14.0,),
                      ),
                      onPressed: (){
                        ShopCubit.get(context).changeFavorites(model.id);
                      })
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);