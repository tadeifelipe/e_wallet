defmodule EWalletConsumer.Kafka.Consumer do
  use Broadway

  alias Broadway.Message
  alias EWalletService.Operations.Create, as: CreateOperation
  require Logger

  @broker [localhost: 9092]
  @topic ["e_wallet_topic"]

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: @broker,
             group_id: "group_1",
             topics: @topic
           ]}
      ],
      processors: [
        default: [concurrency: 50]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{data: data} = message, _) do
    Logger.info("Got message from topic: #{@topic}")

    operation = Jason.decode!(data)

    with {:ok, _} <- CreateOperation.call(operation) do
      message
    else
      {:error, reason} -> handle_error(reason, message)
    end
  end

  @impl true
  def handle_batch(:errors, messages, _, _) do
    Logger.error("Got #{Enum.count(messages)} in :errors batcher")
    messages
  end

  defp handle_error(reason, message) do
    Logger.error("Error on execute operation: #{reason}")

    message
    |> Message.failed(reason)
    |> Message.put_batcher(:errors)
  end
end
