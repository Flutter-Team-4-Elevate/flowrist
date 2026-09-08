import 'package:flutter_test/flutter_test.dart';

import 'package:flowrist/features/home/home/data/models/home_model/banner_payload_model.dart';
import 'package:flowrist/features/home/home/data/models/home_model/home_response_model.dart';

void main() {
  group('HomeResponseModel', () {
    group('fromJson', () {
      test('should create HomeResponseModel from valid banner JSON', () {
        // Arrange
        final json = {
          'id': 'layout-1',
          'type': 'banner',
          'title': 'Spring Sale',
          'order': 1,
          'isEnabled': true,
          'payload': {
            'type': 'banner',
            'imageUrl': "imageUrl",
            'clickAction': "clickAction",
            // Add the actual BannerPayloadModel fields here.
          },
        };

        // Act
        final result = HomeResponseModel.fromJson(json);

        // Assert
        expect(result.id, 'layout-1');
        expect(result.type, 'banner');
        expect(result.title, 'Spring Sale');
        expect(result.order, 1);
        expect(result.isEnabled, true);

        expect(result.payload, isA<BannerPayloadModel>());
      });
    });

    group('toEntity', () {
      test('should convert HomeResponseModel to HomeLayoutEntity', () {
        // Arrange
        final json = {
          'id': 'layout-1',
          'type': 'banner',
          'title': 'Spring Sale',
          'order': 1,
          'isEnabled': true,
          'payload': {
            'type': 'banner',
            'imageUrl': "imageUrl",
            'clickAction': "clickAction",
            // Add the actual BannerPayloadModel fields here.
          },
        };

        final model = HomeResponseModel.fromJson(json);

        // Act
        final result = model.toEntity();

        // Assert
        expect(result.id, model.id);
        expect(result.type, model.type);
        expect(result.title, model.title);
        expect(result.order, model.order);
        expect(result.isEnabled, model.isEnabled);
      });
    });

    group('toJson', () {
      test('should convert model to JSON without payload', () {
        // Arrange
        final json = {
          'id': 'layout-1',
          'type': 'banner',
          'title': 'Spring Sale',
          'order': 1,
          'isEnabled': true,
          'payload': {
            'type': 'banner',
            'imageUrl': "imageUrl",
            'clickAction': "clickAction",
            // Add the actual BannerPayloadModel fields here.
          },
        };

        final model = HomeResponseModel.fromJson(json);

        // Act
        final result = model.toJson();

        // Assert
        expect(result['id'], 'layout-1');
        expect(result['type'], 'banner');
        expect(result['title'], 'Spring Sale');
        expect(result['order'], 1);
        expect(result['isEnabled'], true);

        // Because of includeToJson: false
        expect(result.containsKey('payload'), false);
      });
    });
  });
}
