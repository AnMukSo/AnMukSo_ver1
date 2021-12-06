import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/theme/colors.dart';

class PolicyTermPage extends StatefulWidget {
  @override
  _PolicyTermPageState createState() => _PolicyTermPageState();
}

class _PolicyTermPageState extends State<PolicyTermPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWithGoToBack('이용약관', Icon(Icons.arrow_back), 0.5),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          //TODO:이용약관 넣어두기
          child: FutureBuilder<Terms>(
              future: getTerms(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Terms privacy = snapshot.data;

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
                          '\n\n제 1 조 (목적)\n',
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
                          '\n\n제 2 조 (정의)\n',
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
                          '\n\n제 3 조 (약관의 게시와 개정)\n',
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
                          '\n\n제 4 조 (약관의 해석)\n',
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
                          '\n\n제 5 조 (이용계약 체결)\n',
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
                          '\n\n제 6 조 (회원정보의 변경)\n',
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
                          '\n\n제 7 조 (개인정보보호 의무)\n',
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
                          '\n\n제 8 조 (“회원”의 “아이디” 및 “비밀번호”의 관리에 대한 의무)\n',
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
                          '\n\n제 9 조 (“회원”에 대한 통지)\n',
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
                          '\n\n제 10 조 (“회사”의 의무)\n',
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
                          '\n\n제 11 조 (“회원”의 의무)\n',
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
                        Text(
                          '\n\n제 12 조 (“서비스”의 제공 등)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list12.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list12[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 13 조 (“서비스”의 변경)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list13.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list13[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 14 조 (정보의 제공 및 광고의 게재)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list14.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list14[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 15 조 (“게시물”의 저작권)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list15.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list15[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 16 조 (“게시물”의 관리)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list16.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list16[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 17 조 (권리의 귀속)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list17.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list17[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 18 조 (계약해제, 해지 등)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list18.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list18[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 19 조 (이용요금 및 환불정책)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list19.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list19[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 20 조 (책임과 손해 배상)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list20.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list20[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 21 조 (이용제한 등)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list21.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list21[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 22 조 (책임 제한)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list22.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list22[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 23 조 (회사의 면책)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list23.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list23[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 24 조 (준거법 및 재판관할)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list24.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list24[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 25 조 (상품 리뷰)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list25.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list25[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n제 26 조 (안먹소 검증단 평가)\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list26.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list26[index].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: gray600, height: 1.6));
                            }),
                        Text(
                          '\n\n[부칙]\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary600_bold_text),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: privacy.list999.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(privacy.list999[index].toString(),
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

class Terms {
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
  final List list12;
  final List list13;
  final List list14;
  final List list15;
  final List list16;
  final List list17;
  final List list18;
  final List list19;
  final List list20;
  final List list21;
  final List list22;
  final List list23;
  final List list24;
  final List list25;
  final List list26;
  final List list999;

  Terms(
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
      this.list11,
      this.list12,
      this.list13,
      this.list14,
      this.list15,
      this.list16,
      this.list17,
      this.list18,
      this.list19,
      this.list20,
      this.list21,
      this.list22,
      this.list23,
      this.list24,
      this.list25,
        this.list26,
        this.list999
      });
}

final CollectionReference policyCollection =
    FirebaseFirestore.instance.collection('Policy');

Future<Terms> getTerms() async {
  DocumentSnapshot ds = await policyCollection.doc('privacy').get();
  return Terms(
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
    list12: ds.data()['12'] ?? '',
    list13: ds.data()['13'] ?? '',
    list14: ds.data()['14'] ?? '',
    list15: ds.data()['15'] ?? '',
    list16: ds.data()['16'] ?? '',
    list17: ds.data()['17'] ?? '',
    list18: ds.data()['18'] ?? '',
    list19: ds.data()['19'] ?? '',
    list20: ds.data()['20'] ?? '',
    list21: ds.data()['21'] ?? '',
    list22: ds.data()['22'] ?? '',
    list23: ds.data()['23'] ?? '',
    list24: ds.data()['24'] ?? '',
    list25: ds.data()['25'] ?? '',
    list26: ds.data()['26'] ?? '',
    list999: ds.data()['999'] ?? '',
  );
}
