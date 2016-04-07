library angular2.src.transform.common.rewrite_utils;

import 'package:barback/barback.dart';

import 'names.dart';

class RewriteResult {
  final AssetId assetId;
  final String code;
  final bool isModified;

  RewriteResult(this.assetId, this.code, this.isModified);
}

void maybeAddModifiedOutput(Transform transform, RewriteResult result) {
  if (result.isModified) {
    transform.addOutput(new Asset.fromBytes(
        result.assetId.addExtension(MODIFIED_EXTENSION), const <int>[]));
  }
}
