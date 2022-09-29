import 'package:an_muk_so/services/auth.dart';
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
  final AuthService _auth = AuthService();

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
    String nickName = '';

    if (user.uid != null) {
      print('결제 부분 페이지에 잘 들어갔나? 값 업데이트 해줘야 ');
      print('결제 상태 ${provider.isPurchased} ');
      //구독이 되어있으면
      if (provider.isPurchased) {
        DatabaseService(uid: user.uid).updateSubscribeUser('done');
      }
      //구독이 안 되어있으면 어떻게 하나 이건 한달뒤에 체크 가능
      else {
        //미리 결제 했던 사람들에 한에서
        DatabaseService(uid: user.uid).updateSubscribeUser('not yet');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(" 정기 구독 결제 "),
        //backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            // //Navigator.pop(context);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/login', (Route<dynamic> route) => false);
            await _auth.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/start', (Route<dynamic> route) => false);
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        SizedBox(height: 30,),
                        //유저 데이타가 있을 경우 bottombar 가기
                        FlatButton(
                          onPressed: () async {
                            try {
                              nickName = await DatabaseService(uid: user.uid)
                                  .getNickName();
                              if (nickName.isNotEmpty) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/bottom_bar',
                                    (Route<dynamic> route) => false);
                              }
                            } catch (e) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/policy_agree',
                                  (Route<dynamic> route) => false);
                            }
                          },
                          child: Text(
                            '안먹소 시작하기',
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                          color: primary300_main,
                        ),
                        SizedBox(height: 15,),
                      ],
                    ))
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "안먹소를 사용하시기 위해서\n정기 구독이 필요합니다",
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          '\n정기구독결재 회원이 되시면 \n안먹소 앱 내에 검증된 먹거리 리스트를 \n실시간으로 검색 해 보실수 있으며\n정기적으로 업데이트 되어\n유용한 생활건강정보를 앱을 통해 주기적으로 받아 보실 수 있습니다.\n',
                          style: Theme.of(context).textTheme.subtitle2,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
              for (var prod in provider.products)
                if (provider.hasPurchased(prod.id) != null) ...[
                  Center(
                    child: FittedBox(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '안전한 먹거리 소비자 연합',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6.copyWith(color: primary300_main),
                              ),
                              Text('에서',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                          Text(
                            '독성물질에 민감한 정예회원들이\n안전한 먹거리를 엄선하여\n추천한 제품을 검색해 줍니다.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
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
