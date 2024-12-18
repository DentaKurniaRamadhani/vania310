import 'package:vania/vania.dart';

class CreateProductNoteTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('productnotes', () {
      bigIncrements('note_id');
      primary('note_id');
      bigInt('prod_id', unsigned: true);
      date('note_date');
      text('note_text');
      timeStamps();
      foreign('prod_id', 'products', 'prod_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('productnotes');
  }
}
