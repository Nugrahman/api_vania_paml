import 'package:api_vania_paml/app/models/product_note.dart';
import 'package:vania/vania.dart';

class ProductNoteControllers extends Controller {
  Future<Response> index() async {
    try {
      var customers = await ProductNote().query().get();
      return Response.json(customers);
    } catch (e) {
      return Response.json({'message': e.toString()});
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var prodId = request.input("prod_id");
      var noteDate = request.input("note_date");
      var noteText = request.input("note_text");

      await ProductNote().query().insert({
        'prod_id': prodId,
        'note_date': noteDate,
        'note_text': noteText,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
      });

      return Response.json({
        'success': true,
        'message': 'Data berhasil disimpan',
        'code': 200,
      });
    } catch (e) {
      return Response.json({"success": false, 'error': e.toString()});
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    try {
      var prodId = request.input("prod_id");
      var noteDate = request.input("note_date");
      var noteText = request.input("note_text");

      await ProductNote().query().where('id', '=', id).update({
        'prod_id': prodId,
        'note_date': noteDate,
        'note_text': noteText,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
      });

      return Response.json({
        'success': true,
        'message': 'Data berhasil disimpan',
        'code': 200,
      });
    } catch (e) {
      return Response.json({"success": false, 'error': e.toString()});
    }
  }

  Future<Response> destroy(int id) async {
    try {
      await ProductNote().query().where('id', '=', id).delete();
      return Response.json({
        'success': true,
        'message': 'Data berhasil dihapus',
        'code': 200,
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': e.toString(),
        'code': 500,
      });
    }
  }
}

final ProductNoteControllers productNoteControllers = ProductNoteControllers();