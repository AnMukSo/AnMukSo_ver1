import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'provider.dart';
import 'dart:async';

class SubscribeHomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<SubscribeHomeScreen> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  @override
  void initState() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.verifyPurchase();
    super.initState();
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    var provider = Provider.of<ProviderModel>(context);
    var userDataCheck = false;

    if (user.uid != null) {
      print('결제 부분 페이지에 잘 들어갔나? 값 업데이트 해줘야 ');
      print('결제 상태 ${provider.isPurchased} ');
      userDataCheck = true;
      //구독이 되어있으면
      if (provider.isPurchased) {
        DatabaseService(uid: user.uid).updateSubscribeUser('done');
      }
      //구독이 안 되어있으면 어떻게 하나 이건 한달뒤에 체크 가능
      else {
        //미리 결제 했던 사람들에 한에서
       // DatabaseService(uid: user.uid).updateSubscribeUser('not yet');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(" 정기 구독 결제 "),
        //backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //Navigator.pop(context);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image(
                        image:
                            AssetImage('assets/an_icon_resize/An_Logo.png'))),
              ),
              provider.isPurchased
                  ? Center(
                      child: Column(
                      children: [
                        Text(
                          "안먹소 프리미엄 버전 입니다.",
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                        //유저 데이타가 있을 경우 bottombar 가기
                        userDataCheck
                            ? FlatButton(
                                onPressed: () async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/bottom_bar',
                                      (Route<dynamic> route) => false);
                                },
                                child: Text(
                                  '안먹소 사용하기',
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.center,
                                ),
                                color: primary300_main,
                              )
                            :
                            //유저 데이타가 없을 경우 policy 가기
                            FlatButton(
                                onPressed: () async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/policy_agree',
                                      (Route<dynamic> route) => false);
                                },
                                child: Text(
                                  '안먹소 등록하기',
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.center,
                                ),
                                color: primary300_main,
                              )
                      ],
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "안먹소를 사용하시기 위해서\n정기 구독이 필요합니다.",
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ),
              for (var prod in provider.products)
                if (provider.hasPurchased(prod.id) != null) ...[
                  Center(
                    child: FittedBox(
                      child: Text(
                        'THANK YOU!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                  ),
                ] else ...[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "정기 구독 금액 : ${prod.price} ",
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FlatButton(
                          onPressed: () async {
                            _buyProduct(prod);
                          },
                          child: Text('결제하기'),
                          color: primary300_main,
                        ),
                      ],
                    ),
                  ),
                ]
            ],
          ),
        ),
      ),
    );
  }
}
