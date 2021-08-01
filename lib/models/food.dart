class Food {
  final String barCode;

  //final String chart; // 성상 (본품은 백색의 정제다.)
  //final List eeDocData;

  final String entpName;
  //final String entpNo;
  //final String etcOtcCode; // 일반의약품, 전문의약품

  final String ingrName; // 의약품 첨가제
  final String itemName; //

  final String itemSeq;
  //final String mainItemIngr; // 유효성분 (염산에페드린)
  final String materialName; // 원료성분 (1정 중 80밀리그램,염산에페드린,KP,25,밀리그램)
  final List nbDocData;

  //final String permitKindName; // 허가, 신고 구분
  //final String storageMethod;
  //final String totalContect; // (1000밀리리터 중)

 // final List udDocData;
 // final String udDocId;
 // final String validTerm;

  final num totalRating;
  final num numOfReviews;
  final List searchNameList;
  //final List pharmacistTips;

  final String rankCategory;

  Food(
      {this.barCode,

        //this.chart,

        //this.eeDocData,

        this.entpName,
        //this.entpNo,
        //this.etcOtcCode,

        this.ingrName,
        this.itemName,

        this.itemSeq,
        //this.mainItemIngr,
        this.materialName,
        this.nbDocData,

        //this.permitKindName,
        //this.storageMethod,
        //this.totalContect,
        //this.udDocData,
        //this.udDocId,
        //this.validTerm,

        //this.category,
        this.totalRating,
        this.numOfReviews,
        this.searchNameList,
        //this.pharmacistTips,
        this.rankCategory
      });
}


class SavedFood {
  final String itemName;
  final String itemSeq;
  final String category;
  final String expiration;
  final String etcOtcCode;
  final List searchNameList;
  final DateTime savedTime;

  SavedFood({
    this.itemName,
    this.itemSeq,
    this.category,
    this.expiration,
    this.etcOtcCode,
    this.searchNameList,
    this.savedTime
  });
}
