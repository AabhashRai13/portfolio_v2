import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/blog_detail/data/datasources/blog_detail_remote_data_source.dart';

void main() {
  test('can be created before Firebase is up', () {
    var resolved = false;
    BlogDetailRemoteDataSource(
      firestore: () {
        resolved = true;
        throw StateError('Firebase is not up');
      },
    );

    expect(resolved, isFalse);
  });
}
