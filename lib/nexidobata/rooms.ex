defmodule Nexidobata.Rooms do
  @room_list_query """
  query {
    viewer {
      rooms {
        edges {
          node {
            id
            name
            organization {
              slug
            }
  } } } } }
  """

  defmodule Organization, do: defstruct [:slug]
  defmodule Node, do: defstruct [:id, :name, :organization]
  defmodule Edge, do: defstruct [:node]
  defmodule Rooms, do: defstruct [:edges]
  defmodule Viewer, do: defstruct [:rooms]
  defmodule Data, do: defstruct [:viewer]
  defmodule Response, do: defstruct [:data]

  alias Nexidobata.Rooms.{Response, Data, Viewer, Rooms, Edge, Node, Organization}

  def response_structure do
    %Response{
      data: %Data{
        viewer: %Viewer{
          rooms: %Rooms{
            edges: [
              %Edge{
                node: %Node{
                  organization: %Organization{}
                }
              }
            ]
          }
        }
      }
    }
  end

  def rooms(bearer) do
    data = Poison.encode!(%{query: @room_list_query})
    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{bearer}"
    }

    case HTTPoison.post(Nexidobata.graphql_url(), data, headers) do
      {:ok, %HTTPoison.Response{status_code: status_code} = resp} when status_code <= 299 ->
        Poison.decode!(resp.body, as: response_structure()).data.viewer.rooms.edges

      {:ok, %HTTPoison.Response{} = resp} ->
        IO.puts(:stderr, """
        Failed to listing rooms.
        Status: #{resp.status_code}
        Body:
        #{resp.body}
        """)
        exit({:shutdown, 1})

      {:error, %HTTPoison.Error{} = error} ->
        IO.puts(:stderr, """
        Failed to listing rooms.
        Reason: #{Exception.message(error)}
        """)
        exit({:shutdown, 1})
    end
  end
end
