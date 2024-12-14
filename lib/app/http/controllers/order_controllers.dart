import 'package:api_vania_paml/app/models/order.dart';
import 'package:api_vania_paml/app/models/order_item.dart';
import 'package:api_vania_paml/app/models/product.dart';
import 'package:vania/vania.dart';

class OrderControllers extends Controller {
  Future<Response> index() async {
    try {
      var customers = await Order().query().get();
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
      // Get order date and customer ID from request
      var orderDate = request.input('order_date');
      var customerId = request.input('cust_id');

      // Get order items from request and validate if not empty
      var orderItems = request.input('order_items') as List;
      if (orderItems.isEmpty) {
        return Response.json({
          'success': false,
          'message': 'Order items is empty',
        });
      }

      // Generate unique order number and create new order in database
      var orderId = await Order().query().insertGetId({
        'order_date': orderDate,
        'cust_id': customerId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Initialize list to store processed order items
      List<Map<String, dynamic>> savedOrderItems = [];

      // Process each item in the order
      for (var item in orderItems) {
        if (item is Map) {
          // Extract item details
          var prodId = item['prod_id'];
          var quantity = item['quantity'];
          var size = item['size'];

          // Validate item fields are not null
          if (prodId == null || quantity == null || size == null) {
            return Response.json({
              'success': false,
              'message': 'Order items is invalid',
            });
          }

          // Check if product exists in database
          var isProductExist =
              await Product().query().where('id', '=', prodId).first();

          if (isProductExist == null) {
            return Response.json({
              'success': false,
              'message': 'Product not found',
            });
          }

          // Prepare order item data for database insertion
          var orderItemData = {
            'order_num': orderId,
            'prod_id': isProductExist['id'],
            'quantity': quantity,
            'size': size,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          // Insert order item into database
          await OrderItem().query().insert(orderItemData);

          // Add processed item to saved items list
          savedOrderItems.add(orderItemData);
        }
      }

      // Return success response with order details
      return Response.json({
        'success': true,
        'message': 'Order created successfully',
        'data': {
          'orders': await Order().query().where('id', '=', orderId).first(),
          'order_items': savedOrderItems,
        }
      });
    } catch (e) {
      // Return error response if any exception occurs
      return Response.json({
        'success': false,
        'message': 'Failed to create order',
        'error': e.toString()
      });
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    return Response.json({});
  }

  Future<Response> destroy(int id) async {
    try {
      // Delete order items associated with the order
      await OrderItem().query().where('order_num', '=', id).delete();

      // Delete the order
      await Order().query().where('id', '=', id).delete();

      // Return success response
      return Response.json({
        'success': true,
        'message': 'Order deleted successfully',
      });
    } catch (e) {
      // Return error response if any exception occurs
      return Response.json({
        'success': false,
        'message': 'Failed to delete order',
        'error': e.toString()
      });
    }
  }
}

final OrderControllers orderControllers = OrderControllers();