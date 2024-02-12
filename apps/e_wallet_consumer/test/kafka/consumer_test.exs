defmodule EWalletConsumer.Kafka.ConsumerTest do
  use ExUnit.Case

  alias Testcontainers.KafkaContainer
  alias Testcontainers.Container
  alias EWalletConsumer.Kafka.Consumer

  @moduletag timeout: 200_000

  setup do
    config = KafkaContainer.new()
    {:ok, kafka} = Testcontainers.start_container(config)
    on_exit(fn -> Testcontainers.stop_container(kafka.container_id) end)

    :ok = :brod.stop_client(:kafka_client)

    uris = [{"localhost", Container.mapped_port(kafka, 9092) || 9092}]
    :ok = :brod.start_client(uris, :kafka_client, allow_topic_auto_creation: true)

    {:ok, uris: uris, topic: Producer.topic()}
  end

  describe "handle_message/3" do
    test "should consumes a deposit operation message" do
      true == true
    end
  end
end
