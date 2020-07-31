
import 'dart:developer';

import "package:dart_amqp/dart_amqp.dart";

class RabbitMQComponent{

  Channel channel;
  Queue queue;

  RabbitMQComponent();

  Future<bool> sendMessage(Client connection, String queueName, String message) async{
    try {
      channel = await connection.channel();
      queue = await channel.queue(queueName, durable: true);
      queue.publish(message);
      return true;
    } on ConnectionFailedException catch(e){
      log(e.message);
    } catch(e){
      log(e.toString());
    }
    return false;
  }
}