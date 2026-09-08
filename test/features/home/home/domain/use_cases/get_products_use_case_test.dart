import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/occasions_repository.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_products_use_case.dart';

import 'get_products_use_case_test.mocks.dart';

@GenerateMocks([OccasionsRepository])
void main() {
  late GetProductsUseCase useCase;
  late MockOccasionsRepository mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );
  });

  setUp(() {
    mockRepository = MockOccasionsRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  final tProducts = [
    const ProductEntity(
      id: '1',
      name: 'Red Bouquet',
      price: 150.0,
      inStock: true,
      categoryId: 'c1',
      categoryName: 'Bouquets',
      imageUrl: 'image.png',
    ),
  ];

  test(
    'should return products filtered by occasionId and categoryId',
    () async {
      when(
        mockRepository.getProducts(occasionId: 'occ1', categoryId: 'cat1'),
      ).thenAnswer((_) async => SuccessResponse(tProducts));

      final result = await useCase(occasionId: 'occ1', categoryId: 'cat1');

      expect(result, isA<SuccessResponse<List<ProductEntity>>>());
      expect((result as SuccessResponse).data, tProducts);
      verify(
        mockRepository.getProducts(occasionId: 'occ1', categoryId: 'cat1'),
      ).called(1);
    },
  );
}
