import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/blog_list/data/datasources/blog_list_remote_data_source.dart';

void main() {
  test('can be created before Firebase is up', () {
    var resolved = false;
    BlogListRemoteDataSource(
      firestore: () {
        resolved = true;
        throw StateError('Firebase is not up');
      },
    );

    expect(resolved, isFalse);
  });
}
