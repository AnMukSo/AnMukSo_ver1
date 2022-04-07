import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:an_muk_so/search/search_result_list_tile.dart';
import 'package:an_muk_so/models/food.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/services/db.dart';

import 'package:an_muk_so/review/food_info.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/theme/colors.dart';

import 'indicator.dart';

//(1) 하이라이팅을 위함
String _searchText = "";
TextStyle posRes = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: primary500_light_text),
    negRes = TextStyle(
        fontFamily: 'NotoSansKR',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: gray900,
        backgroundColor: Colors.white);

TextSpan searchMatch(String match) {
  if (_searchText == null || _searchText == "")
    return TextSpan(text: match, style: negRes);
  var refinedMatch = match; // .toLowerCase();
  var refinedSearch = _searchText; // .toLowerCase();
  if (refinedMatch.contains(refinedSearch)) {
    if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
      return TextSpan(
        style: posRes,
        text: match.substring(0, refinedSearch.length),
        children: [
          searchMatch(
            match.substring(
              refinedSearch.length,
            ),
          ),
        ],
      );
    } else if (refinedMatch.length == refinedSearch.length) {
      return TextSpan(text: match, style: posRes);
    } else {
      return TextSpan(
        style: negRes,
        text: match.substring(
          0,
          refinedMatch.indexOf(refinedSearch),
        ),
        children: [
          searchMatch(
            match.substring(
              refinedMatch.indexOf(refinedSearch),
            ),
          ),
        ],
      );
    }
  } else if (!refinedMatch.contains(refinedSearch)) {
    return TextSpan(text: match, style: negRes);
  }
  return TextSpan(
    text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
    style: negRes,
    children: [
      searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
    ],
  );
}
//(1) 여기까지

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  //String _searchText = "";

  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  //전체삭제했을 때 dialog
  void showWarning(BuildContext context, String bodyString,
      String leftButtonName, String rightButtonName, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          // title:
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(bodyString,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      leftButtonName,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: primary400_line),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: gray50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: gray100))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                      child: Text(
                        rightButtonName,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: gray0_white),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          primary: primary300_main,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: primary400_line))),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('searchList')
                            .get()
                            .then((snapshot) {
                          for (DocumentSnapshot ds in snapshot.docs) {
                            ds.reference.delete();
                          }
                        });
                      })
                ],
              )
            ],
          ),
        );
      },
    );
  }

  //이름 길었을 때 필요한 부분만 짤라서 보여주려고 하는 거였는데 모든 조건들이 적용 되지는 않음
  String _checkLongName(String data) {
    String newName = data;
    List splitName = [];
    if (data.contains('(')) {
      newName = data.replaceAll('(', '(');
      if (newName.contains('')) {
        splitName = newName.split('(');
        newName = splitName[0];
      }
    }
    return newName;
  }

  Widget _noResultContainer() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            '검색 결과가 없습니다',
            style:
            Theme.of(context).textTheme.headline5.copyWith(color: gray500),
          )),
    );
  }

  Widget _streamOfSearch(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    return StreamBuilder<QuerySnapshot>(
      stream: userSearchList.orderBy('time', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.length == 0)
          return Container(
            padding: EdgeInsets.only(top: 30),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('찾고자 하는 상품을 검색해주세요',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: gray500))),
          );
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 30,
                    child: Center(
                        child: Text('    최근 검색어',
                            style: Theme.of(context).textTheme.subtitle1))),
                FlatButton(
                  child: Text('전체 삭제',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 13)),
                  onPressed: () {
                    //print('삭제되었음');
                    showWarning(
                        context, '정말 전체 삭제 하시겠어요?', '취소', '삭제', user.uid);
                  },
                )
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                children: snapshot.data.docs
                    .map((data) => _buildRecentSearchList(context, data))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _foodListFromUser(context, userFood) {
    //여기는 user 안에 있는 친구들 불러오는 거!!
    String searchList;
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    Future<void> addRecentSearchList() async {
      try {
        assert(userFood.itemName != null);

        searchList = _checkLongName(userFood.itemName);
        assert(searchList != null);
        //food 이름 누르면 저장 기능
        userSearchList.add({
          'searchList': searchList,
          'time': DateTime.now(),
          'itemSeq': userFood.itemSeq
        });
      } catch (e) {
        print('Error: $e');
      }
    }

    QuerySnapshot _query;
    return GestureDetector(
        onTap: () async => {
          _query = await userSearchList
              .where('searchList',
              isEqualTo: _checkLongName(userFood.itemName))
              .get(),
          if (_query.docs.length == 0)
            {
              addRecentSearchList(),
            },
          //Navigator.pop(context),
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewPage(userFood.itemSeq),
              )),
        },
        child: Container(
          padding: EdgeInsets.only(left: 16, bottom: 4),
          height: 40,
          child: Row(
            children: [
              Text(
                _checkLongName(userFood.itemName),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: primary500_light_text),
              ),
              SizedBox(
                width: 10,
              ),
              Text(userFood.expiration,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 10, color: gray300_inactivated))
            ],
          ),
        ));
  }

  Widget _buildBodyOfAll(BuildContext context, String searchVal) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<List<Food>>(
      stream: DatabaseService() //categoryName: widget.categoryName
          .setForSearchFromAllAfterRemainStartAt(searchVal, 30),
      builder: (context, stream) {
        // if (!stream.hasData) {
        //   return Center(child: CircularProgressIndicator());
        // }
        if (searchVal == '' || searchVal.length < 2) {
          return _streamOfSearch(context);
        }
        if (!stream.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        // else
        else if (stream.data.isEmpty) {
          return _noResultContainer();
        } else {
          var streamFromAll = stream.data;
          return StreamBuilder<List<Food>>(
              stream: DatabaseService() //categoryName: widget.categoryName
                  .setForSearchFromAllStartAtSearch(searchVal, 30),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var streamFromMatchStart = snapshot.data;
                  return StreamBuilder<List<SavedFood>>(
                      stream: DatabaseService(
                          uid: user.uid) //categoryName: widget.categoryName
                          .setForSearchFromUser(searchVal, 30),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else
                          return CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    //유저가 가지고 있는 부분
                                    _buildListOfAll(
                                        context,
                                        streamFromAll,
                                        streamFromMatchStart,
                                        snapshot.data,
                                        'USER'),
                                    _buildListOfAll(
                                        context,
                                        streamFromAll,
                                        streamFromMatchStart,
                                        snapshot.data,
                                        'START'),
                                    _buildListOfAll(
                                        context,
                                        streamFromAll,
                                        streamFromMatchStart,
                                        snapshot.data,
                                        'withoutUser'),
                                  ],
                                ),
                              ),
                            ],
                          );
                      });
                }
              });
        }
      },
    );
    //}
  }


  Widget _buildListOfAll(BuildContext context, List<Food> foods,  List<Food> SAFoods, List<SavedFood> userFoods,
      String type) {
    //유저가 가지고 있는 상품이 있을 때,
    if (!userFoods.isEmpty) {
      if (type == 'USER') {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFCACCCC)),
              borderRadius: BorderRadius.circular(5),
            ),
            //padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(top: 12.0, left: 12, bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        color: Color(0xFFCACCCC),
                        size: 22,
                      ),
                      Text(
                        ' 나의 리스트',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: gray500),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: userFoods.length,
                  itemBuilder: (context, index) {
                    return _foodListFromUser(context, userFoods[index]);
                  },
                ),
              ],
            ),
          ),
        );
      }
      if (type == 'START') {
        return Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: SAFoods.length,
              itemBuilder: (context, index) {
                for (int j = 0; j < userFoods.length; j++) {
                  //유저가 가지고 있는 상품과 겹치는 부분은 제외해준다
                  if (SAFoods[index].itemName == userFoods[j].itemName) {
                    return Container();
                  }
                }
                return SearchResultTile(
                  food: SAFoods[index],
                );
              },
            ),
          ],
        );
      } else if (type == 'withoutUser') {
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            ///TODO: 이부분에서 에러가 나서 잠시 주석 달아놨는데 에러가 사라짐 왜그런지 이유를 알아야 함
            //유저가 가지고 있는 애들 제외
            // for (int i = 0; i < foods.length; i++) {
            //   if (foods[index].itemName == userFoods[i].itemName) {
            //     return Container();
            //   }
            // }
            //앞에 나온 애들 제외
            for (int j = 0; j < SAFoods.length; j++) {
              if (foods[index].itemName == SAFoods[j].itemName) {

                return Container();
              }
            }

            return SearchResultTile(
                food: foods[index], index: index, totNum: foods.length );
          },
        );
      }
    }

    //유저가 가지고 있는 상품이 없을 때
    if (type == 'START') {
      return Column(
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: SAFoods.length,
            itemBuilder: (context, index) {
              return SearchResultTile(
                food: SAFoods[index],
              );
            },
          ),
        ],
      );
    } else if (type == 'withoutUser') {
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          //앞에 나온 애들 제외
          for (int j = 0; j < SAFoods.length; j++) {
            if (foods[index].itemName == SAFoods[j].itemName) {
              return Container();
            }
          }
          int totCount = foods.length - SAFoods.length;


          return SearchResultTile(
              food: foods[index], index: index, totNum: totCount );
        },
      );
    } else
      return Container();
    //}
  }

  Widget _buildBodyOfUser(BuildContext context, String searchVal) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<List<SavedFood>>(
      stream: DatabaseService(uid: user.uid) //categoryName: widget.categoryName
          .setForSearchFromUser(searchVal, 10),
      builder: (context, stream) {
        if (!stream.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (searchVal == '' || searchVal.length < 2) {
          return _streamOfSearch(context);
        } else if (stream.data.isEmpty) {
          return _noResultContainer();
        } else
          //return _buildListOfUser(context, stream.data);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    //유저가 가지고 있는 부분
                    _buildListOfUser(context, stream.data)
                  ],
                ),
              ),
            ],
          );
      },
    );
  }

  Widget _buildListOfUser(BuildContext context, List<SavedFood> userFoods) {
    // if (_searchText.length < 2) {
    //   return _noResultContainer();
    // } else {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFCACCCC)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12, bottom: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_border,
                    color: Color(0xFFCACCCC),
                    size: 22,
                  ),
                  Text(
                    ' 나의 리스트',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: gray500),
                  )
                ],
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: userFoods.length,
              itemBuilder: (context, index) {
                return _foodListFromUser(context, userFoods[index]);
              },
            ),
          ],
        ),
      ),
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('상품 검색',  Image(
          image: AssetImage('assets/an_icon_resize/An_Back.png')), 0.5),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _searchBar(context),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: _myTab(_searchText),
            )
          ],
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    String searchList;
    double mw = MediaQuery.of(context).size.width;

    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    Future<void> addRecentSearchList() async {
      try {
        assert(_searchText != null);
        searchList = _searchText;
        assert(searchList != null);
        //검색어 저장 기능 array로 저장해주기
        userSearchList.add({'searchList': searchList, 'time': DateTime.now()});
      } catch (e) {
        print('Error: $e');
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 9),
      child: Row(
        children: [
          Container(
            width: mw - 32 ,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: gray75,
            ),
            child: Row(
              children: [
                Expanded(
                  // flex: 5,
                    child: TextFormField(
                      cursorColor: primary300_main,
                      onFieldSubmitted: (val) async {
                        if (val != '' || val.length > 2) {
                          QuerySnapshot _query = await userSearchList
                              .where('searchList', isEqualTo: val)
                              .get();
                          if (_query.docs.length == 0) {
                            if (searchList != '') addRecentSearchList();
                          }
                          focusNode.unfocus();
                        }
                      },
                      focusNode: focusNode,
                      style: Theme.of(context).textTheme.bodyText2,
                      autofocus: true,
                      controller: _filter,
                      decoration: InputDecoration(
                          suffixIcon: _filter.text.length > 0
                              ? IconButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              onPressed: () {
                                setState(() {
                                  _filter.clear();
                                  _searchText = "";
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                size: 20,
                                color: gray300_inactivated,
                              ))
                              : null,
                          //),
                          fillColor: gray50,
                          filled: true,
                          prefixIcon: SizedBox(
                            height: 10,
                            width: 10,
                            child: Padding(
                              padding:
                              const EdgeInsets.only(top: 4.0, bottom: 4),
                              child:
                              Image.asset('assets/an_icon_resize/An_Search.png'),
                            ),
                          ),
                          hintText: '상품명을 두 글자 이상 입력해주세요',
                          hintStyle:
                          Theme.of(context).textTheme.bodyText2.copyWith(
                            color: gray300_inactivated,
                          ),
                          contentPadding: EdgeInsets.zero,
                          labelStyle:
                          Theme.of(context).textTheme.bodyText2.copyWith(
                            color: gray300_inactivated,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: gray75)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: gray75)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                  color: gray75),
                              borderRadius: BorderRadius.circular(8.0))),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myTab(String searchVal) {
    double height = MediaQuery.of(context).size.height;

    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 10.0, right: 16.0, bottom: 10),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    color: gray75,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                //color: gray75,
                child: TabBar(
                    labelStyle: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: gray750_activated, fontSize: 13),
                    unselectedLabelStyle: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith( color: gray500),
                    tabs: [
                      Tab(
                          child: Container(
                            width: 100,
                            child: Center(
                              child: Text(
                                  '전체 검색',
                                  style:  TextStyle(color: gray750_activated, fontFamily: 'NotoSansKR')                        ),
                            ),
                          )),
                      Tab(
                          child: Text(
                              '나의 리스트 검색',
                              style:  TextStyle(color: gray750_activated, fontFamily: 'NotoSansKR')                        )),
                    ],
                    indicator: CustomTabIndicator()
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(0.0),
              width: double.infinity,
              height: height - 160, //440.0,
              child: TabBarView(
                children: [
                  //_buildWithUserOfAll(context, searchVal),
                  _buildBodyOfAll(context, searchVal),
                  _buildBodyOfUser(context, searchVal)
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildRecentSearchList(BuildContext context, DocumentSnapshot data) {
    final searchSnapshot = RecentSearch.fromSnapshot(data);
    final docID = data.id;
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    Future<void> updateRecentSearchList() async {
      try {
        assert(_searchText != null);

        //검색어 저장 기능 array로 저장해주기
        userSearchList.doc(docID).update({'time': DateTime.now()});
      } catch (e) {
        print('Error: $e');
      }
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () async => {
            _searchText = searchSnapshot.recent,
            _filter.text = _searchText,
            updateRecentSearchList()
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.4, color: Colors.grey[400]))),
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: 45.0,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(searchSnapshot.recent,
                      style: Theme.of(context).textTheme.bodyText2),
                ),
                Spacer(),
                SizedBox(
                  width: 25,
                  child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        //print(docID);
                        userSearchList.doc(docID).delete();
                      },
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xffB1B2B2),
                      )),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RecentSearch {
  final String recent;
  final Timestamp time;
  final String itemSeq;

  final DocumentReference reference;

  RecentSearch.fromMap(Map<String, dynamic> map, {this.reference})
      : recent = map['searchList'],
        itemSeq = map['itemSeq'],
        time = map['time'];

  RecentSearch.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
