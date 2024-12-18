// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';
import 'package:api__3_1_0/app/models/customer.dart';
import 'package:vania/vania.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    try {
      final customer = await Customer().query().get();
      return Response.json(customer);
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
        'cust_name': 'required|string|max_length:100',
        'cust_address': 'required|string|max_length:255',
        'cust_city': 'required|string|max_length:50',
        'cust_state': 'required|string|max_length:50',
        'cust_zip': 'required',
        'cust_country': 'required|string',
        'cust_telp': 'required|max_length:13'
      }, {
        'cust_name.required': 'Form name harus di isi',
        'cust_name.string': 'input nama harus text',
        'cust_name.max_length': 'input nama max 100 karakter',
        'cust_address.required': 'Form alamat harus di isi',
        'cust_address.string': 'input alamat harus text',
        'cust_address.max_length': 'input alamat max 225 karakter',
        'cust_city.required': 'Form kota harus di isi',
        'cust_city.string': 'input kota harus text',
        'cust_city.max_length': 'input kota max 50 karakter',
        'cust_state.required': 'Form provinsi harus di isi',
        'cust_state.string': 'input provinsi harus text',
        'cust_state.max_length': 'input provinsi max 50 karakter',
        'cust_zip.required': 'Form kode pos harus di isi',
        'cust_zip.string': 'input kode pos harus text',
        'cust_country.required': 'Form negara harus di isi',
        'cust_country.string': 'input negara harus text',
        'cust_telp.required': 'Form nomor telepon harus di isi',
        'cust_telp.max_length': 'input nomor telepon max 13 karakter'
      });
      final customer = request.input();
      final existingCustomer = await Customer()
          .query()
          .where('cust_name', '=', customer['cust_name'])
          .first();
      if (existingCustomer != null) {
        return Response.json(
            {'message': 'Customer dengan nama ini sudah ada'}, 409);
      }
      customer['created_at'] = DateTime.now().toIso8601String();
      await Customer().query().insert(customer);
      return Response.json(
          {'message': 'Customer berhasil ditambahkan', 'data': customer}, 201);
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
      final customer =
          await Customer().query().where('cust_id', '=', id).first();

      return Response.json({'success': true, 'data': customer});
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
        'cust_name': 'required|string|max_length:100',
        'cust_address': 'required|string|max_length:255',
        'cust_city': 'required|string|max_length:50',
        'cust_state': 'required|string|max_length:50',
        'cust_zip': 'required',
        'cust_country': 'required|string',
        'cust_telp': 'required|max_length:13'
      }, {
        'cust_name.required': 'Form name harus di isi',
        'cust_name.string': 'input nama harus text',
        'cust_name.max_length': 'input nama max 100 karakter',
        'cust_address.required': 'Form alamat harus di isi',
        'cust_address.string': 'input alamat harus text',
        'cust_address.max_length': 'input alamat max 225 karakter',
        'cust_city.required': 'Form kota harus di isi',
        'cust_city.string': 'input kota harus text',
        'cust_city.max_length': 'input kota max 50 karakter',
        'cust_state.required': 'Form provinsi harus di isi',
        'cust_state.string': 'input provinsi harus text',
        'cust_state.max_length': 'input provinsi max 50 karakter',
        'cust_zip.required': 'Form kode pos harus di isi',
        'cust_zip.string': 'input kode pos harus text',
        'cust_country.required': 'Form negara harus di isi',
        'cust_country.string': 'input negara harus text',
        'cust_telp.required': 'Form nomor telepon harus di isi',
        'cust_telp.max_length': 'input nomor telepon max 13 karakter'
      });
      //mengambil input data yang customer yang akan di update
      final customerData = request.input();

      if (customerData.containsKey('id')) {
        customerData['cust_id'] = customerData['id'];
        customerData.remove('id');
      }
      print('data yang dikirim $customerData');
      customerData['updated_at'] = DateTime.now().toIso8601String();
      final customer =
          await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({
          'message': 'Customer dengan ID $id tidak ditemukan.',
        }, 404);
      }
      await Customer().query().where('cust_id', '=', id).update(customerData);
      return Response.json({
        'message': 'Customer berhasil di perbaharui',
        'data': customerData,
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
      final product =
          await Customer().query().where('cust_id', '=', id).delete();

      if (product == 0) {
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

final CustomerController customerController = CustomerController();
