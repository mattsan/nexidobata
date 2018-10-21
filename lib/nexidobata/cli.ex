defmodule Nexidobata.CLI do
  alias Nexidobata.{Help, Init, Post, Rooms}

  @post_options [
    pre: :string,
    title: :string,
    format: :string
  ]

  def main([]) do
    help([])
  end

  def main([command | args]) do
    case command do
      "help" -> help(args)
      "init" -> init(args)
      "post" -> post(args)
      "rooms" -> rooms(args)
      _ -> help(args)
    end
  end

  def help(args) do
    Help.help(args)
  end

  def init(_) do
    email = IO.gets("Email: ") |> String.trim_trailing("\n")
    password = IO.gets("Password: ") |> String.trim_trailing("\n")

    Init.init(email, password)
  end

  def post([org_slug, room_name | args]) do
    case OptionParser.parse(args, strict: @post_options) do
      {options, messages, []} ->
        message =
          case messages do
            [] -> IO.read(:stdio, :all)
            _ -> Enum.join(messages, " ")
          end
        Post.post(bearer(), org_slug, room_name, message, options)

      {_, messages, errors} ->
        IO.puts "error #{messages} #{inspect(errors)}"
    end
  end

  def post(args), do: help(args)

  def rooms([]), do: rooms([nil])

  def rooms([org_slug]) do
    Rooms.rooms(bearer())
    |> Enum.map(fn edge ->
      {
        edge.node.organization.slug,
        edge.node.name
      }
    end)
    |> Enum.sort()
    |> Enum.each(fn
      {slug, room_name} when is_nil(org_slug) or (slug == org_slug) -> IO.puts("#{slug}/#{room_name}")
      _ -> :ok
    end)
  end

  def rooms(args), do: help(args)

  defp bearer, do: "TODO get token from .netrc"
end
