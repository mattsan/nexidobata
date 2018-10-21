defmodule Nexidobata.Init do
  def init(email, password) do
    url = URI.merge(Nexidobata.idobata_url(), "/oauth/token")
    {:ok, data} =
      Poison.encode(%{
        grant_type: "password",
        username: email,
        password: password
      })
    headers = %{"Content-Type" => "application/json"}

    case HTTPoison.post(url, data, headers) do
      {:ok, %HTTPoison.Response{status_code: status_code} = resp} when status_code <= 299 ->
        token = Poison.decode!(resp.body)["access_token"]
        # TODO save token to .netrc
        IO.puts(token)

      {:ok, %HTTPoison.Response{status_code: 401}} ->
        IO.puts(:stderr, "Authentication failed. You may have entered wrong Email or Password.")
        exit({:shutdown, 1})

      {:ok, %HTTPoison.Response{} = resp} ->
        IO.puts(:stderr, """
        Failed to initialize.
        Status: #{resp.status_code}
        Body:
        #{resp.body}
        """)
        exit({:shutdown, 1})

      {:error, %HTTPoison.Error{} = error} ->
        IO.puts(:stderr, """
        Failed to initialize.
        Reason: #{Exception.message(error)}
        """)
        exit({:shutdown, 1})
    end
  end
end
