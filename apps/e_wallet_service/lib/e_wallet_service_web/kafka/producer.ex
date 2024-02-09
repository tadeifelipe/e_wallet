defmodule EWalletServiceWeb.Kafka.Producer do
  alias EWalletServiceWeb.Kafka.ProducerBehaviour
  require Logger

  @behaviour ProducerBehaviour

  @broker [{"localhost", 9092}]
  @topic "e_wallet_topic"

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(opts) do
    connect_to_kafka()
    {:ok, opts}
  end

  defp connect_to_kafka() do
    Logger.info("Trying to connect with kafka")

    with :ok <- :brod.start_client(@broker, :kafka_client, allow_topic_auto_creation: true) do
      case :brod.start_producer(:kafka_client, @topic, []) do
        :ok -> Logger.info("Connected to Kafka")
        {:error, _} -> Logger.error("Could not connect to Kafka")
      end
    end
  end

  @impl ProducerBehaviour
  def call({:ok, message}, operation), do: produce(message, operation)

  def call({:error, _} = message, _operation), do: message

  defp produce(message, operation) do
    json_message =
      Jason.encode!(%{
        operation: operation,
        id: message.id
      })

    Logger.info("Sending message to kafka: #{json_message}")

    case :brod.produce_sync(
           :kafka_client,
           @topic,
           :hash,
           Integer.to_string(message.id),
           json_message
         ) do
      :ok -> {:ok, message}
      {:error, reason} -> {:error, reason}
    end
  end

  def topic(), do: @topic
end
