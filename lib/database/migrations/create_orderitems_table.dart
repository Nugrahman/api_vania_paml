import 'package:vania/vania.dart';

class CreateOrderitemsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      id();
      bigInt('order_num', unsigned: true);
      foreign('order_num', 'orders', 'id',
          constrained: true, onDelete: 'CASCADE');
      bigInt('prod_id', unsigned: true);
      foreign('prod_id', 'products', 'id',
          constrained: true, onDelete: 'CASCADE');
      integer('quantity');
      integer('size');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}