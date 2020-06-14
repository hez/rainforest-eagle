defmodule RainforestEagle do
  require Logger

  @headers [{"content-type", "text/xml"}]
  @mac_template_id "$MAC$"
  @current_summation_request "<Command><Name>get_current_summation</Name><MacId>#{
                               @mac_template_id
                             }</MacId></Command>"

  def current_summation(mac), do: @current_summation_request |> insert_mac(mac) |> send()

  def send(cmd) do
    config = config()

    config
    |> Keyword.get(:url)
    |> HTTPoison.post(cmd, headers(config))
    |> get_response_body()
  end

  def get_usage({:ok, xml}), do: get_usage(xml)
  def get_usage(xml), do: get_hex_value(xml, "SummationDelivered")

  def get_hex_value(xml, tag) do
    ~r/<#{tag}>0x(?<value>.*)<\/#{tag}>/
    |> Regex.named_captures(xml)
    |> Map.get("value")
    |> Integer.parse(16)
    |> elem(0)
  end

  def config, do: Application.get_env(:rainforest_eagle, :connection, [])
  def mac_id, do: Keyword.get(config(), :mac_id)

  defp get_response_body({:ok, %{body: body}}), do: {:ok, body}
  defp get_response_body(resp), do: resp

  defp headers(config) do
    List.insert_at(
      @headers,
      0,
      {"authorization", "Basic #{Base.encode64(Keyword.get(config, :basic_auth))}"}
    )
  end

  defp insert_mac(cmd, mac), do: String.replace(cmd, @mac_template_id, mac)
end
