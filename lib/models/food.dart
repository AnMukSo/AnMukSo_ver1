class Food {
  final String barCode; //바코드 숫자
  final String entpName; //회사이름

 // final String ingrName; // 음식 첨가제??
  final String itemName; // 상품 이름

  final String itemSeq; //상품 고유 번호
//  final String materialName; // 원료성분??
  final String warningData; //주의사항
  final String itemCountry; //원산지

  final num totalRating; //별점
  final num numOfReviews; //리뷰 개수
  final List searchNameList; //검색어 이름

  final String rankCategory; //카테고리

  Food(
      {this.barCode,

        this.entpName,
      //  this.ingrName,
        this.itemName,

        this.itemSeq,
      //  this.materialName,
        this.warningData,
        this.itemCountry, //원산지

        this.totalRating,
        this.numOfReviews,
        this.searchNameList,
        this.rankCategory
      });
}


class SavedFood {
  final String itemName;
  final String itemSeq;
  final String rankCategory;
  final String expiration;
  final String etcOtcCode;
  final List searchNameList;
  final DateTime savedTime;

  SavedFood({
    this.itemName,
    this.itemSeq,
    this.rankCategory,
    this.expiration,
    this.etcOtcCode,
    this.searchNameList,
    this.savedTime
  });
}

//새로운 상품이 추가 되을 경우
class NewFood {
  final String barCode; //바코드 숫자
  final String entpName; //회사이름

  // final String ingrName; // 음식 첨가제??
  final String itemName; // 상품 이름

  final String itemSeq; //상품 고유 번호
//  final String materialName; // 원료성분??
  final String warningData; //주의사항
  final String itemCountry; //원산지

  final num totalRating; //별점
  final num numOfReviews; //리뷰 개수
  final List searchNameList; //검색어 이름

  final String rankCategory; //카테고리

  NewFood(
      {this.barCode,

        this.entpName,
        //  this.ingrName,
        this.itemName,

        this.itemSeq,
        //  this.materialName,
        this.warningData,
        this.itemCountry, //원산지

        this.totalRating,
        this.numOfReviews,
        this.searchNameList,
        this.rankCategory
      });
}