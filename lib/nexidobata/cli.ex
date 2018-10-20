defmodule Nexidobata.CLI do
  @idobata_url URI.parse("https://idobata.io")

  def main([]) do
    help([])
  end

  def main([command | args]) do
    case command do
      "help" -> help(args)
      "init" -> init(args)
      "post" -> post(args)
      "room" -> room(args)
    end
  end

  def help(["init"]) do
    IO.puts("""
    Usage:
      nidobata init

    Init nidobata
    """)
  end

  def help(["post"]) do
    IO.puts("""
    Usage:
      nidobata post ORG_SLUG ROOM_NAME [MESSAGE] [--pre] [--title] [--format]

    Options:
      [--pre=PRE]        # can be used syntax highlight if argument exists
      [--title=TITLE]
      [--format=FORMAT]  # it is ignored if pre argument exists

    Post a message from stdin or 2nd argument.
    """)
  end

  def help(["room"]) do
    IO.puts("""
    Usage:
      nidobata rooms [ORG_SLUG]

    list rooms
    """)
  end

  def help(_) do
    IO.puts("""
    Commands:
      nidobata help [COMMAND]                                                  # Describe available commands or one specific command
      nidobata init                                                            # Init nidobata
      nidobata post ORG_SLUG ROOM_NAME [MESSAGE] [--pre] [--title] [--format]  # Post a message from stdin or 2nd argument.
      nidobata rooms [ORG_SLUG]                                                # list rooms
    """)
  end

  def init(_) do
    IO.gets("Email: ")
    IO.gets("Password: ")
  end

  @options [
    pre: :string,
    title: :string,
    format: :string
  ]

  def post([org_slug, room_name | args]) do
    case OptionParser.parse(args, strict: @options) do
      {_options, [], []} ->
        IO.puts "post < stdin"

      {_options, [message], []} ->
        IO.puts "post #{message}"

      {_, messages, errors} ->
        IO.puts "error #{messages} #{inspect(errors)}"
    end
  end

  def room(_) do
  end
end
