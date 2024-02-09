defmodule EWalletServiceWeb.Kafka.ProducerTest do
  use ExUnit.Case

  alias Testcontainers.KafkaContainer
  alias Testcontainers.Container
  alias EWalletServiceWeb.Kafka.Producer

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

  describe "call/2" do
    test "should publish a message to topic kafka", %{uris: uris, topic: topic} do
      create_topic(uris, topic)

      params = %{
        id: 1,
        msg: "teste message"
      }

      {:ok, message} = Producer.call({:ok, params}, :test_operation)

      response =
        :brod.fetch(:kafka_client, topic, 0, 0)
        |> get_message()

      expected_response = "{\"id\":1,\"operation\":\"test_operation\"}"

      assert message == params
      assert response == expected_response
    end
  end

  defp get_message(response) do
    case response do
      {:ok,
       {_offset, [{:kafka_message, _partition, _key, value, _timestamp, _headers, _metadata}]}} ->
        value

      {:error, reason} ->
        IO.puts("Error: #{reason}")

      _ ->
        IO.puts("Unexpected response format")
    end
  end

  defp create_topic(uris, topic) do
    config_topic = [
      %{
        assignments: [],
        configs: [],
        name: topic,
        num_partitions: 1,
        replication_factor: 1
      }
    ]

    :ok = :brod.create_topics(uris, config_topic, %{timeout: 3_000})
    :ok = :brod.start_producer(:kafka_client, topic, [])
  end
end
