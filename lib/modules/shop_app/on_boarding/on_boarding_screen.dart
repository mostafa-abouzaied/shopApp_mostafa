import 'package:flutter/material.dart';
import 'package:reuseable_componets/modules/shop_app/login/shop_login_screen.dart';
import 'package:reuseable_componets/shared/components/components.dart';
import 'package:reuseable_componets/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String title;
  final String body;
  final String image;

  BoardingModel({this.title, this.body, this.image});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        title: 'Screen Boarding 1 title ',
        image: 'assets/images/onboarding_1.jpg',
        body: 'Screen Boarding 1 body'),
    BoardingModel(
        title: 'Screen Boarding 2 title ',
        image: 'assets/images/onboarding_2.png',
        body: 'Screen Boarding 2 body'),
    BoardingModel(
        title: 'Screen Boarding 3 title ',
        image: 'assets/images/onboarding_3.png',
        body: 'Screen Boarding 3 body'),
  ];
  bool isLast = false;
  void submit (){
    CacheHelper.saveData(key:'onBoarding', value:true).then((value)  {
      if (value){
        navigateAndFinish(context, ShopLoginScreen());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            defaultTextButton(
                function: submit,

                text: 'skip'),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (int index) {
                    if (index == boarding.length - 1) {
                      print('last');
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        print('NotLast');
                        isLast = false;
                      });
                    }
                  },
                  physics: BouncingScrollPhysics(),
                  controller: boardController,
                  itemBuilder: (context, index) =>
                      buildBoardingItem(boarding[index]),
                  itemCount: boarding.length,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                      controller: boardController,
                      effect: ExpandingDotsEffect(
                        dotHeight: 10.0,
                        dotWidth: 10.0,
                        activeDotColor: Colors.deepOrange,
                        dotColor: Colors.grey,
                        expansionFactor: 4,
                        spacing: 5.0,
                      ),
                      count: boarding.length),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        boardController.nextPage(
                            duration: Duration(
                              milliseconds: 750,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage('${model.image}'),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            '${model.title}',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            '${model.body}',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
