import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      id();
      bigInt('vend_id', unsigned: true);
      foreign('vend_id', 'vendors', 'id',
          constrained: true, onDelete: 'CASCADE');
      string('prod_name');
      integer('prod_price');
      text('prod_desc');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}