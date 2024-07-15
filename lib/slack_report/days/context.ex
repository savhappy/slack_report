defmodule SlackReport.Days do
  @moduledoc """
  Business context for day reports.
  """
  alias SlackReport.Repo

  import Ecto.Query

  @doc """
  Returns list of of all transactions from database that match given order date.
  """
  def fetch_all_by_date(date) do
    off_by_one = Timex.shift(date, days: -1)
    off_by_two = Timex.shift(date, days: -2)
    off_by_eight = Timex.shift(date, days: -8)

    from(d in SlackReport.Day,
      select: d,
      where:
        d.order_date == ^off_by_one or d.order_date == ^off_by_two or
          d.order_date == ^off_by_eight
    )
    |> Repo.all()
  end

  @doc """
  'calculate_total' aggregates the fetehd transactions get transactions from the previous day, the day before the previous day, and the same day last week.
  It calculates the total revenue based on the field we are looking at and rejects any results that have no value attached.

  ex.   %{
      "customer_id" => "6106765328560",
      "discount_codes" => "", <- this value that is grouped will not be included in top threee
      "discounts" => "0",
      "gross_revenue" => "49.99",
      "order_date" => "43936",
      "order_id" => "4423220461744",
      "order_type" => "non_subscription",
      "payment_gateway" => "shopify_payments",
      "source_medium" => "paid_fb / cpc"
    }

  """
  def calculate_total(txns, type) do
    grouped_txns =
      Enum.group_by(txns, fn txn ->
        Map.get(txn, type)
      end)

    net_rev = calculate_net_rev(grouped_txns)
    percent = calculate_percent(net_rev)

    percentage = take_top_three(percent)
    revenue = take_top_three(net_rev)

    combine(revenue, percentage)
  end

  def calculate_net_rev(txns) do
    for {order_type, report_list} <- txns do
      total_revenue =
        report_list
        |> Enum.reduce(0.0, fn report, acc ->
          revenue = is_whole_num(report.gross_revenue)
          discount = is_whole_num(report.discounts)
          acc + revenue - discount
        end)

      {order_type, Float.round(total_revenue, 2)}
    end
    |> Map.new()
  end

  def calculate_percent(values) do
    total_sum = Map.values(values) |> Enum.sum()

    values
    |> Enum.map(fn {key, value} ->
      percentage = value / total_sum * 100
      {key, Float.round(percentage, 2)}
    end)
    |> Map.new()
  end

  defp take_top_three(map) do
    Enum.reject(map, fn {key, _} -> key == "" end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> Enum.take(3)
  end

  defp is_whole_num(value) do
    if String.contains?(value, ".") do
      value
      |> String.split(" ")
      |> Enum.at(0)
      |> String.to_float()
    else
      value
      |> String.split(" ")
      |> Enum.at(0)
      |> String.to_integer()
    end
  end

  defp combine(list1, list2) do
    map2 = Map.new(list2, & &1)

    Enum.map(list1, fn {key, value1} ->
      {key, value1, Map.get(map2, key)}
    end)
  end
end
