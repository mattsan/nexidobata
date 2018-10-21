defmodule Nexidobata do
  @moduledoc """
  Documentation for Nexidobata.
  """

  @idobata_url URI.parse("https://idobata.io")
  @graphql_url URI.parse("https://api.idobata.io/graphql")

  def idobata_url, do: @idobata_url
  def graphql_url, do: @graphql_url
end
