import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/models/shop_app/category_model.dart';
import 'package:reuseable_componets/models/shop_app/home_model.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/cubit.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/states.dart';
import 'package:reuseable_componets/shared/components/components.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessChangeFavoritesState){
if (! state.model.status){
  showToast(text: state.model.message,state: ToastStates.ERROR);
}
        }
      },
      builder: (context, state) {
        return ShopCubit.get(context).homeModel != null&&ShopCubit.get(context).categoriesModel != null
            ? productsBuilder(ShopCubit.get(context).homeModel,ShopCubit.get(context).categoriesModel,context)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget productsBuilder(HomeModel model,CategoriesModel categoriesModel,context) => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data.banners
                  .map((e) => Image(
                        image: NetworkImage('${e.image}'),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(
                  seconds: 3,
                ),
                autoPlayAnimationDuration: Duration(
                  seconds: 1,
                ),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categories', style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800
                  ),),
                  Container(
                    height: 100.0,
                    width:double.infinity,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index)=>buildCategoryItem(categoriesModel.data.data[index]),
                        separatorBuilder:(context, index)=> SizedBox(
                          width: 10.0,
                        ),
                        itemCount:categoriesModel.data.data.length),
                  ),
                  Text('New Products', style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800
                  ),),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.58,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(model.data.products.length,
                    (index) => buildGridProduct(model.data.products[index],context)),
              ),
            ),
          ],
        ),
      );

  Widget buildGridProduct(ProductsModel model,context) => Container(
        color: Colors.white,
        child: Column(
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
                if(model.discount != 0)
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1.3),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if(model.discount!=0)
                      Text(
                        '${model.oldPrice.round()}',
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
      );
  Widget buildCategoryItem(DataModel model)=>Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage(model.image),
        height: 100.0,
        width: 100.0,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(0.8),
        width: 100.0,
        child: Text(model.name,
          textAlign: TextAlign.center,
          maxLines:1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color:Colors.white,
          ),),
      )
    ],
  );
}
