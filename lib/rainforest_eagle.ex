defmodule RainforestEagle do
  require Logger

  @default_path "/cgi-bin/post_manager"
  @headers [{"content-type", "text/xml"}]
  @mac_template_id "$MAC$"
  @current_summation_request "<Command><Name>get_current_summation</Name><MacId>#{
                               @mac_template_id
                             }</MacId></Command>"
  @current_summation_response_tag "SummationDelivered"

  def current_summation, do: @current_summation_request |> insert_mac() |> send() |> get_usage()

  def send(cmd) do
    config = config()
    path = Keyword.get(config, :path, @default_path)

    config
    |> client()
    |> Tesla.post(path, cmd)
  end

  def get_usage(resp), do: get_hex_value(resp, @current_summation_response_tag)

  def get_hex_value({:ok, %{status: 200, body: xml}}, tag), do: get_hex_value(xml, tag)

  def get_hex_value(xml, tag) when is_binary(xml) and is_binary(tag) do
    ~r/<#{tag}>0x(?<value>.*)<\/#{tag}>/
    |> Regex.named_captures(xml)
    |> Map.get("value")
    |> Integer.parse(16)
    |> elem(0)
  end

  def config, do: Application.get_env(:rainforest_eagle, :connection, [])
  def interval, do: Keyword.get(config(), :refresh_interval, 120)
  def mac_id, do: Keyword.get(config(), :mac_id)

  defp insert_mac(cmd), do: String.replace(cmd, @mac_template_id, mac_id())

  defp client(config) do
    middleware = [
      {Tesla.Middleware.BaseUrl, Keyword.get(config, :host)},
      {Tesla.Middleware.Headers, @headers},
      {Tesla.Middleware.BasicAuth,
       %{username: Keyword.get(config, :username), password: Keyword.get(config, :password)}}
    ]

    Tesla.client(middleware)
  end
end
