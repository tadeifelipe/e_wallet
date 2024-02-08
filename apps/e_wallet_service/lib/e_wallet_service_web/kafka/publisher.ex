defmodule EWalletServiceWeb.Kafka.Publisher do
  alias EWalletServiceWeb.Kafka.PublisherBehaviour

  @behaviour PublisherBehaviour

  @brokers [{"localhost", 9092}]
  @topic "e_wallet_topic"

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(opts) do
    connect_to_kafka()
    {:ok, opts}
  end

  defp connect_to_kafka() do
    :ok = :brod.start_client(@brokers, :kafka_client, allow_topic_auto_creation: true)
    :brod.start_producer(:kafka_client, @topic, [])
  end

  @impl PublisherBehaviour
  def call({:ok, message}, operation), do: publish(message, operation)

  def call({:error, _} = message, _operation), do: message

  defp publish(message, operation) do
    json_message =
      Jason.encode!(%{
        operation: operation,
        id: message.id
      })

    case :brod.produce_sync(
           :kafka_client,
           @topic,
           :hash,
           Integer.to_string(message.id),
           json_message
         ) do
      :ok -> {:ok, message}
      {:error, _} -> {:error, :error_to_send_topic}
    end
  end
end
