defmodule SlackReport.Days.Parser do
  @moduledoc """
  Pseudo layer of fetching from Shopify

  Processes the CSV data from the given file path by parsing, formatting, and chunking it into
  batches of 1000 elements before inserting them into the database.
  """
  alias SlackReport.Day

  NimbleCSV.define(Parser, separator: ",", escape: "\\")

  @file_path "assets/sourcemedium-test-project-dataset.csv"

  @doc """
  process_csv/1
  Invokes the parse_titles/1 function to get the column titles.
  Reads the CSV data from the file path and processes it:
  Parses the CSV data using Parser module.
  Formats the data rows with the titles using format/2.
  Chunks the data into batches of 1000 elements.
  Utilizes an Ecto.Multi transaction to insert each batch into the database using Day schema.
  """

  def process_csv(file_path \\ @file_path) do
    titles = parse_titles(file_path)

    data =
      File.stream!(file_path)
      |> Parser.parse_stream()
      |> Stream.map(fn values -> format(titles, values) end)
      |> Stream.chunk_every(1000)
      |> Enum.to_list()

    Enum.each(data, fn rows ->
      Ecto.Multi.new()
      |> Ecto.Multi.insert_all(:insert_all, Day, rows)
      |> SlackReport.Repo.transaction()
    end)
  end

  def parse_titles(file_path) do
    csv_data = File.read!(file_path)
    [column_titles | _rows] = csv_data |> String.split("\r", trim: true)

    column_titles
    |> String.split(",")
  end

  def format(titles, values) do
    data =
      Enum.zip(titles, values)
      |> Enum.reduce(%{}, fn {title, value}, acc -> Map.put(acc, String.to_atom(title), value) end)

    %{
      order_date: excel_date_to_elixir_date(data.order_date),
      order_id: data.order_id,
      customer_id: data.customer_id,
      source_medium: data.source_medium,
      gross_revenue: data.gross_revenue,
      discounts: data.discounts,
      discount_codes: data.discount_codes,
      payment_gateway: data.payment_gateway,
      order_type: data.order_type
    }
  end

  defp excel_date_to_elixir_date(excel_date) do
    date = String.to_integer(excel_date)
    {:ok, excel_epoch} = Date.from_erl({1899, 12, 30})

    excel_days = date - 1
    Date.add(excel_epoch, excel_days)
  end
end
