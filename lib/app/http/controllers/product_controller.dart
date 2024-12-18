// ignore: implementation_imports

import 'package:api__3_1_0/app/models/vendor.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';
import 'package:api__3_1_0/app/models/product.dart';
import 'package:vania/vania.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    try {
      final products = await Product().query().get();
      return Response.json(products);
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
        'vend_id': 'required|max_length:100',
        'prod_name': 'required|string|max_length:255',
        'prod_price': 'required|max_length:50',
        'prod_desc': 'required|string|max_length:50'
      }, {
        'vend_id.required': 'Form name harus di isi',
        'vend_id.max_length': 'input nama max 100 karakter',
        'prod_name.required': 'Form alamat harus di isi',
        'prod_name.string': 'input alamat harus text',
        'prod_name.max_length': 'input alamat max 225 karakter',
        'prod_price.required': 'Form kota harus di isi',
        'prod_price.max_length': 'input kota max 50 karakter',
        'prod_desc.required': 'Form provinsi harus di isi',
        'prod_desc.string': 'input provinsi harus text',
        'prod_desc.max_length': 'input provinsi max 50 karakter'
      });
      final product = request.input();
      final vendor = product['vend_id'];
      final vendorCount =
          await Vendor().query().where('vend_id', '=', vendor).count();
      final vendorExist = vendorCount > 0;
      if (!vendorExist) {
        return Response.json(
            {'message': 'Vendor dengan id ini tidak tersedia'}, 400);
      }
      final existingProduct = await Product()
          .query()
          .where('prod_name', '=', product['prod_name'])
          .first();
      if (existingProduct != null) {
        return Response.json(
            {'message': 'Produk dengan nama ini sudah ada'}, 409);
      }
      product['created_at'] = DateTime.now().toIso8601String();
      await Product().query().insert(product);
      return Response.json(
          {'message': 'Produk berhasil ditambahkan', 'data': product}, 201);
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

  Future<Response> show(Request request, int id) async {
    try {
      final product = await Product().query().where('prod_id', '=', id).first();

      return Response.json({'success': true, 'data': product});
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
        'vend_id': 'required|max_length:100',
        'prod_name': 'required|string|max_length:255',
        'prod_price': 'required|max_length:50',
        'prod_desc': 'required|string|max_length:50'
      }, {
        'vend_id.required': 'Form vendor id harus di isi',
        'vend_id.max_length': 'input vendor id max 100 karakter',
        'prod_name.required': 'Form nama produk harus di isi',
        'prod_name.string': 'input nama produk harus text',
        'prod_name.max_length': 'input nama produk max 225 karakter',
        'prod_price.required': 'Form harga produk di isi',
        'prod_price.max_length': 'input harga produk max 50 karakter',
        'prod_desc.required': 'Form keterangan harus di isi',
        'prod_desc.string': 'input keterangan harus text',
        'prod_desc.max_length': 'input keterangan max 50 karakter'
      });
      //mengambil input data yang produk yang akan di update
      final productData = request.input();

      if (productData.containsKey('id')) {
        productData['prod_id'] = productData['id'];
        productData.remove('id');
      }
      print('data yang dikirim $productData');
      productData['updated_at'] = DateTime.now().toIso8601String();
      final product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }
      await Product().query().where('prod_id', '=', id).update(productData);
      return Response.json({
        'message': 'Produk berhasil di perbaharui',
        'data': productData,
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
          await Product().query().where('prod_id', '=', id).delete();

      if (product == 0) {
        return Response.json({
          'error': 'Not Found',
          'message': 'Product with id $id not found',
        });
      }

      return Response.json({'message': 'Product deleted successfully'});
    } catch (e) {
      return Response.json({
        'error': 'Bad Request',
        'message': e.toString(),
      });
    }
  }
}

final ProductController productController = ProductController();
