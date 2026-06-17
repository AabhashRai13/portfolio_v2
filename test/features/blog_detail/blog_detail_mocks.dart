// This file exists purely to carry the @GenerateNiceMocks annotation for
// build_runner. The generated mocks live in blog_detail_mocks.mocks.dart —
// import that file from tests, not this one.
//
// To regenerate after changing any of the mocked interfaces, run:
//   dart run build_runner build --delete-conflicting-outputs

// The `_anchor` function below is deliberately unreferenced — it only exists
// as a target for the @GenerateNiceMocks annotation.
// ignore_for_file: unused_element

import 'package:mockito/annotations.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/blog_detail/domain/repositories/blog_detail_repository.dart';

@GenerateNiceMocks(<MockSpec<Object>>[
  MockSpec<BlogDetailRepository>(),
  MockSpec<AppLaunchService>(),
])
void _anchor() {}
