import 'package:cloud_firestore/cloud_firestore.dart';

class ReportReview {
  final String reviewDocumentId;
  final String reportContent;
  final String effectText;
  final String sideEffectText;
  final String overallText;
  final String itemName;
  final String reporterUid;

  ReportReview({
    this.reviewDocumentId,
    this.reportContent,
    this.effectText,
    this.sideEffectText,
    this.overallText,
    this.itemName,
    this.reporterUid
  });
}