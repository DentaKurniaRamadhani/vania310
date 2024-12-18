// ignore: implementation_imports
import 'package:api__3_1_0/app/models/vendor.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class VendorController extends Controller {
  Future<Response> index() async {
    try {
      final vendor = await Vendor().query().get();
      return Response.json(vendor);
    } catch (e) {
      return Response.json(400);
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'vend_name': 'required|string|max_length:100',
        'vend_address': 'required|string|max_length:255',
        'vend_kota': 'required|string|max_length:50',
        'vend_state': 'required|string|max_length:50',
        'vend_zip': 'required',
        'vend_country': 'required|string'
      }, {
        'vend_name.required': 'Form name harus di isi',
        'vend_name.string': 'input nama harus text',
        'vend_name.max_length': 'input nama max 100 karakter',
        'vend_address.required': 'Form alamat harus di isi',
        'vend_address.string': 'input alamat harus text',
        'vend_address.max_length': 'input alamat max 225 karakter',
        'vend_kota.required': 'Form kota harus di isi',
        'vend_kota.string': 'input kota harus text',
        'vend_kota.max_length': 'input kota max 50 karakter',
        'vend_state.required': 'Form provinsi harus di isi',
        'vend_state.string': 'input provinsi harus text',
        'vend_state.max_length': 'input provinsi max 50 karakter',
        'vend_zip.required': 'Form kode pos harus di isi',
        'vend_zip.string': 'input kode pos harus text',
        'vend_country.required': 'Form negara harus di isi',
        'vend_country.string': 'input negara harus text'
      });
      final vendor = request.input();
      final existingVendor = await Vendor()
          .query()
          .where('vend_name', '=', vendor['vend_name'])
          .first();
      if (existingVendor != null) {
        return Response.json(
            {'message': 'Vendor dengan nama ini sudah ada'}, 409);
      }
      vendor['created_at'] = DateTime.now().toIso8601String();
      await Vendor().query().insert(vendor);
      return Response.json(
          {'message': 'Vendor berhasil ditambahkan', 'data': vendor}, 201);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessage = e.message;
        return Response.json({'error': errorMessage}, 400);
      } else {
        return Response.json(
            {'message': 'Terjadi kesalahan disisi server harap cobalagi nanti'},
            500);
      }
    }
  }

  Future<Response> show(int id) async {
    try {
      final vendor = await Vendor().query().where('vend_id', '=', id).first();

      return Response.json({'success': true, 'data': vendor});
    } catch (e) {
      return Response.json({
        'error': 'Bad Request',
        'message': e.toString(),
      });
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'vend_name': 'required|string|max_length:100',
        'vend_address': 'required|string|max_length:255',
        'vend_kota': 'required|string|max_length:50',
        'vend_state': 'required|string|max_length:50',
        'vend_zip': 'required',
        'vend_country': 'required|string'
      }, {
        'vend_name.required': 'Form name harus di isi',
        'vend_name.string': 'input nama harus text',
        'vend_name.max_length': 'input nama max 100 karakter',
        'vend_address.required': 'Form alamat harus di isi',
        'vend_address.string': 'input alamat harus text',
        'vend_address.max_length': 'input alamat max 225 karakter',
        'vend_kota.required': 'Form kota harus di isi',
        'vend_kota.string': 'input kota harus text',
        'vend_kota.max_length': 'input kota max 50 karakter',
        'vend_state.required': 'Form provinsi harus di isi',
        'vend_state.string': 'input provinsi harus text',
        'vend_state.max_length': 'input provinsi max 50 karakter',
        'vend_zip.required': 'Form kode pos harus di isi',
        'vend_zip.string': 'input kode pos harus text',
        'vend_country.required': 'Form negara harus di isi',
        'vend_country.string': 'input negara harus text'
      });
      //mengambil input data yang customer yang akan di update
      final vendorData = request.input();

      if (vendorData.containsKey('id')) {
        vendorData['vend_id'] = vendorData['id'];
        vendorData.remove('id');
      }
      print('data yang dikirim $vendorData');
      vendorData['updated_at'] = DateTime.now().toIso8601String();
      final vendor = await Vendor().query().where('vend_id', '=', id).first();

      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $id tidak ditemukan.',
        }, 404);
      }
      await Vendor().query().where('vend_id', '=', id).update(vendorData);
      return Response.json({
        'message': 'Vendor berhasil di perbaharui',
        'data': vendorData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessage = e.message;
        return Response.json({'error': errorMessage}, 400);
      } else {
        return Response.json({
          'message':
              'Terjadi kesalahan disisi server. Harap coba kembali nanti',
        }, 500);
      }
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final vendor = await Vendor().query().where('vend_id', '=', id).delete();

      if (vendor == 0) {
        return Response.json({
          'error': 'Not Found',
          'message': 'Customer dengan ID $id  tidak ditemukan',
        });
      }

      return Response.json({'message': 'Customer deleted successfully'});
    } catch (e) {
      return Response.json({
        'error': 'Bad Request',
        'message': e.toString(),
      });
    }
  }
}

final VendorController vendorController = VendorController();
