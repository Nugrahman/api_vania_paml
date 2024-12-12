import 'package:vania/vania.dart';

class CreateProductnotesTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('productnotes', () {
      id();
      bigInt('prod_id', unsigned: true);
      foreign('prod_id', 'products', 'id',
          constrained: true, onDelete: 'CASCADE');
      date('note_date');
      text('note_text');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('productnotes');
  }
}