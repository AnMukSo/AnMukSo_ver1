class TheUser {
  final String uid;

  TheUser({this.uid});
}

class UserData {
  final String uid;
  final String agreeDate;

  final String sex;
  final String nickname;
  final String birthYear;

  final bool isPregnant;
  final List keywordList;
  final List selfKeywordList;

  final List favoriteList;
  final List searchList;

  UserData(
      {this.uid,
        this.agreeDate,
        this.sex,
        this.nickname,
        this.birthYear,
        this.isPregnant,
        this.keywordList,
        this.selfKeywordList,
        this.favoriteList,
        this.searchList});
}

class Lists {
  final List favoriteLists;

  Lists({this.favoriteLists});
}
