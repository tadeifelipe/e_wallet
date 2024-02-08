defmodule EWalletServiceWeb.Kafka.PublisherBehaviour do
  @callback call(Tuple.t(), Atom.t()) :: {:map} | {:error, :atom} | {:ok, :map}
end
