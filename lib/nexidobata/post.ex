defmodule Nexidobata.Post do
  import Nexidobata.Rooms

  def post(bearer, org_slug, room_name, message, options \\ []) do
    room_ids =
      rooms(bearer)
      |> Enum.filter(&(&1.node.organization.slug == org_slug && &1.node.name == room_name))
      |> Enum.map(& &1.node.id)

    case room_ids do
      [room_id] ->
        data = Poison.encode!(%{query: mutation(room_id, message, options)})

        headers = %{
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{bearer}"
        }

        post(data, headers)

      _ ->
        IO.puts(:stderr, """
        Failed to posting message.
        Reason: room #{org_slug}/#{room_name} didn't identified.
        """)

        exit({:shtudown, 1})
    end
  end

  defp post(data, headers) do
    case HTTPoison.post(Nexidobata.graphql_url(), data, headers) do
      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code <= 299 ->
        :ok

      {:ok, %HTTPoison.Response{} = resp} ->
        IO.puts(:stderr, """
        Failed to posting a message.
        Status: #{resp.status_code}
        Body:
        #{resp.body}
        """)

        exit({:shutdown, 1})

      {:error, %HTTPoison.Error{} = error} ->
        IO.puts(:stderr, """
        Failed to posting a message.
        Reason: #{Exception.message(error)}
        """)

        exit({:shutdown, 1})
    end
  end

  defp mutation(room_id, original_message, options) do
    {message, format} =
      case get_in(options, [:pre]) do
        nil ->
          {
            original_message,
            get_in(options, [:format]) || "PLAIN"
          }

        pre ->
          {
            """
            ~~~#{pre}
            #{original_message}
            ~~~
            """,
            "MARKDOWN"
          }
      end

    message =
      case get_in(options, [:title]) do
        nil ->
          message

        title ->
          """
          #{title}

          #{message}
          """
      end

    """
    mutation {
      createMessage(input: {
        roomId: "#{room_id}",
        source: "#{message}",
        format: #{format}
      }) {
        clientMutationId
      }
    }
    """
  end
end
