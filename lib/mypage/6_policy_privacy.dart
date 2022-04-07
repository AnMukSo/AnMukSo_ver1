import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/theme/colors.dart';

class PolicyPrivacyPage extends StatefulWidget {
  @override
  _PolicyPrivacyPageState createState() => _PolicyPrivacyPageState();
}

class _PolicyPrivacyPageState extends State<PolicyPrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            CustomAppBarWithGoToBack('개인정보 처리방침',  Image(
                image: AssetImage('assets/an_icon_resize/An_Back.png')), 0.5),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          //TODO:개인정보 처리방침 데이터 베이스에 넣어두기!
          child: FutureBuilder<Privacy>(
              future: getTerms(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Privacy privacy = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list0.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list0[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 1 조 개인정보 수집 이용 및 보유기간 안내\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list1.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list1[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 2 조 개인정보자동수집 장치의 설치와 운영거부에 관한 사항\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list2.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list2[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 3 조 개인정보의 보유·이용기간 및 파기\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list3.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list3[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 4 조 개인정보 처리 위탁\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list4.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list4[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 5 조 개인정보의 제3자 제공\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list5.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list5[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 6 조 개인 정보의 수정 및 이전\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list6.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list6[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 7 조 개인정보의 안전성 확보조치\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list7.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list7[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 8 조 이용자 및 법정대리인의 권리와 그 행사 방법\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list8.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list8[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 9 조 아동의 개인정보 보호\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list9.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list9[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 10 조 개인정보보호 책임자 및 이용자 권익침해에 대한 구제방법\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list10.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list10[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 11 조 개인정보처리방침 변경에 관한 사항\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list11.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list11[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        SizedBox(height: 20)
                      ],
                    ),
                  );
                } else {
                  return LinearProgressIndicator();
                }
              }),
        ));
  }
}

class Privacy {
  final List list0;
  final List list1;
  final List list2;
  final List list3;
  final List list4;
  final List list5;
  final List list6;
  final List list7;
  final List list8;
  final List list9;
  final List list10;
  final List list11;

  Privacy(
      {this.list0,
      this.list1,
      this.list2,
      this.list3,
      this.list4,
      this.list5,
      this.list6,
      this.list7,
      this.list8,
      this.list9,
      this.list10,
      this.list11});
}

final CollectionReference policyCollection =
    FirebaseFirestore.instance.collection('Policy');

Future<Privacy> getTerms() async {
  DocumentSnapshot ds = await policyCollection.doc('privacy').get();
  return Privacy(
    list0: ds.data()['0'] ?? '',
    list1: ds.data()['1'] ?? '',
    list2: ds.data()['2'] ?? '',
    list3: ds.data()['3'] ?? '',
    list4: ds.data()['4'] ?? '',
    list5: ds.data()['5'] ?? '',
    list6: ds.data()['6'] ?? '',
    list7: ds.data()['7'] ?? '',
    list8: ds.data()['8'] ?? '',
    list9: ds.data()['9'] ?? '',
    list10: ds.data()['10'] ?? '',
    list11: ds.data()['11'] ?? '',
  );
}
