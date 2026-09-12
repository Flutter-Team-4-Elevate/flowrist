import 'package:flowrist/features/home/home/data/factories/home_payload_model_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/home/data/models/home_model/banner_payload_model.dart';
import 'package:flowrist/features/home/home/data/models/home_model/category_rail_payload_model.dart';
import 'package:flowrist/features/home/home/data/models/home_model/occasion_rail_payload_model.dart';
import 'package:flowrist/features/home/home/data/models/home_model/product_rail_payload_model.dart';

void main() {
  late HomePayloadModelFactory factory;

  setUp(() {
    factory = const HomePayloadModelFactory();
  });

  group('HomePayloadModelFactory', () {
    test(
      'should return BannerPayloadModel when type is banner',
      () {
        // Arrange
        final json = {
          'type': 'banner',
          'imageUrl':'image',
          'clickAction':'clickAction'
        };

        // Act
        final result = factory.fromJson(json);

        // Assert
        expect(result, isA<BannerPayloadModel>());
      },
    );

    test(
      'should return CategoryRailPayloadModel when type is category_rail',
      () {
        // Arrange
        final json = {
          'type': 'category_rail',
          'items':[],
          'viewAllAction':'ViewAll'
        };

        // Act
        final result = factory.fromJson(json);

        // Assert
        expect(result, isA<CategoryRailPayloadModel>());
      },
    );

    test(
      'should return ProductRailPayloadModel when type is product_rail',
      () {
        // Arrange
        final json = {
          'type': 'product_rail',
          'items':[],
          'viewAllAction':'ViewAll'
        };

        // Act
        final result = factory.fromJson(json);

        // Assert
        expect(result, isA<ProductRailPayloadModel>());
      },
    );

    test(
      'should return OccasionRailPayloadModel when type is occasion_rail',
      () {
        // Arrange
        final json = {
          'type': 'occasion_rail',
          'items':[],
          'viewAllAction':'ViewAll'
        };

        // Act
        final result = factory.fromJson(json);

        // Assert
        expect(result, isA<OccasionRailPayloadModel>());
      },
    );

    test(
      'should throw UnsupportedError when type is unknown',
      () {
        // Arrange
        final json = {
          'type': 'unknown',
        };

        // Act & Assert
        expect(
          () => factory.fromJson(json),
          throwsA(
            isA<UnsupportedError>(),
          ),
        );
      },
    );

    test(
      'should throw UnsupportedError when type is null',
      () {
        // Arrange
        final json = <String, dynamic>{};

        // Act & Assert
        expect(
          () => factory.fromJson(json),
          throwsA(
            isA<UnsupportedError>(),
          ),
        );
      },
    );
  });
}