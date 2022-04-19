import 'package:flutter/material.dart';
import 'subscribe_screen.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class SubscriptionScreen extends StatefulWidget {

  @override
  _SubscriptionScreen createState() => _SubscriptionScreen();
}

class _SubscriptionScreen extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (context) => ProviderModel(),
      child: Subscription(),
    );
  }
}


class Subscription extends StatefulWidget {

  @override
  _Subscription createState() => _Subscription();
}

class _Subscription extends State<Subscription> {

  @override
  void initState() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.initialize();
    super.initState();
  }

  //이건 있어도 없어도 null 값이 한번 뜸 처리 해봐야 함
  @override
  void dispose() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SubscribeHomeScreen();
  }
}