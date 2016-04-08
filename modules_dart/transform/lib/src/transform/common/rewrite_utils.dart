library angular2.src.transform.common.rewrite_utils;

import 'package:barback/barback.dart';

import 'names.dart';

class RewriteResult {
  final AssetId assetId;
  final String code;
  final bool isModified;

  RewriteResult(this.assetId, this.code, this.isModified);
}

void declareOutput(DeclaringTransform transform) {
  transform.declareOutput(transform.primaryId.addExtension(MODIFIED_EXTENSION));
}

void maybeAddModifiedOutput(Transform transform, RewriteResult result) {
  if (result.isModified) {
    transform.addOutput(new Asset.fromBytes(
        result.assetId.addExtension(MODIFIED_EXTENSION), const <int>[]));
  }
}

class FailIfUnmodifiedTransformer extends AggregateTransformer {
  final String _previousTransformer;

  FailIfUnmodifiedTransformer(this._previousTransformer);

  @override
  dynamic classifyPrimary(AssetId id) => 'key';

  @override
  Future apply(AggregateTransform transform) async {
    final hasModified = await transform.primaryInputs
        .any((asset) => asset.id.path.endsWith(MODIFIED_EXTENSION));
    if (!hasModified) {
      transform.logger.error('$_previousTransformer did not modify any files, '
          'which was likely unintended. Please check your transformer '
          'settings.');
    }
  }
}
