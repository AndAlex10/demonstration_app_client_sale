import 'package:venda_mais_client_buy/components/rabbitmq.component.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements Client  {}
class MockChannel extends Mock implements Channel  {}
class MockQueue extends Mock implements Queue  {}

void main(){
  RabbitMQComponent rabbitMQComponent;
  Client client;
  Channel channel;
  Queue queue;
  setUp(() {
    client = MockClient();
    channel = MockChannel();
    queue = MockQueue();
    rabbitMQComponent = RabbitMQComponent();
  });

  group('Rabbit tests', ()
  {
    test("Send message", () async {
      String queueName = 'order';
      String message = 'message';
      when(client.channel()).thenAnswer((_) async =>
          Future.value(channel));

      when(channel.queue(queueName, durable: true)).thenAnswer((_) async =>
          Future.value(queue));

      when(queue.publish(message)).thenAnswer((_) async =>
          Future.value(null));
      bool response = await rabbitMQComponent.sendMessage(client, queueName, message);
      expect(response, true);

    });

    test("Send message - erro", () async {
      String queueName = 'order';
      String message = 'message';
      when(client.channel()).thenAnswer((_) async =>
          Future.value(channel));

      when(channel.queue(queueName, durable: true)).thenAnswer((_) async =>
          Future.value(null));

      when(queue.publish(message)).thenAnswer((_) async =>
          Future.value(null));
      bool response = await rabbitMQComponent.sendMessage(client, queueName, message);
      expect(response, false);

    });
  });

}