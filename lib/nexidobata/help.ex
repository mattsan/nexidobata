defmodule Nexidobata.Help do
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
end
