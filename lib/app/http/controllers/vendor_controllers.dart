import 'package:api_vania_paml/app/models/vendor.dart';
import 'package:vania/vania.dart';

class VendorControllers extends Controller {
  Future<Response> index() async {
    try {
      var customers = await Vendor().query().get();
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
      var vendName = request.input("vend_name");
      var vendAddress = request.input("vend_address");
      var vendKota = request.input("vend_kota");
      var vendState = request.input("vend_state");
      var vendZip = request.input("vend_zip");
      var vendCountry = request.input("vend_country");

      await Vendor().query().insert({
        'vend_name': vendName,
        'vend_address': vendAddress,
        'vend_kota': vendKota,
        'vend_state': vendState,
        'vend_zip': vendZip,
        'vend_country': vendCountry,
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
      var vendName = request.input("vend_name");
      var vendAddress = request.input("vend_address");
      var vendKota = request.input("vend_kota");
      var vendState = request.input("vend_state");
      var vendZip = request.input("vend_zip");
      var vendCountry = request.input("vend_country");

      await Vendor().query().where('id', '=', id).update({
        'vend_name': vendName,
        'vend_address': vendAddress,
        'vend_kota': vendKota,
        'vend_state': vendState,
        'vend_zip': vendZip,
        'vend_country': vendCountry,
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
      await Vendor().query().where('id', '=', id).delete();
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

final VendorControllers vendorControllers = VendorControllers();