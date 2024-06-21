defmodule SlackReport.Days.Breakdown do
  alias SlackReport.Days

  # get transactions from  It will report metrics from the previous day, the day before the previous day, and the same day last week.

  @set_date Application.compile_env(:slack_bot, :set_date) || ~D[2020-04-15]

  def build_block(date \\ @set_date) do
    txns = Days.fetch_all_by_date(date)

    %{
      blocks: [
        %{
          type: "divider"
        },
        %{
          type: "section",
          text: %{
            type: "mrkdwn",
            text: "*Sales Breakdown (Top 3 by Revenue)*"
          }
        },
        %{
          type: "section",
          text: %{
            type: "mrkdwn",
            text: ":iphone: *Order Type*"
          }
        },
        %{
          type: "context",
          elements: [
            %{
              type: "mrkdwn",
              text: "#{calculate_total(txns, :order_type)}"
            }
          ]
        },
        %{
          type: "section",
          text: %{
            type: "mrkdwn",
            text: ":crystal_ball: *Source/Medium*"
          }
        },
        %{
          type: "context",
          elements: [
            %{
              type: "mrkdwn",
              text: "#{calculate_total(txns, :source_medium)}"
            }
          ]
        },
        %{
          type: "section",
          text: %{
            type: "mrkdwn",
            text: ":page_facing_up: *Discount Codes*"
          }
        },
        %{
          type: "context",
          elements: [
            %{
              type: "mrkdwn",
              text: "#{calculate_total(txns, :discount_codes)}"
            }
          ]
        },
        %{
          type: "section",
          text: %{
            type: "mrkdwn",
            text: ":bank: *Payment Gateways*"
          }
        },
        %{
          type: "context",
          elements: [
            %{
              type: "mrkdwn",
              text: "#{calculate_total(txns, :payment_gateway)}"
            }
          ]
        }
      ]
    }
  end

  def calculate_total(txns, type) do
    grouped_txns =
      Enum.group_by(txns, fn txn ->
        Map.get(txn, type)
      end)

    net_rev =
      for {order_type, report_list} <- grouped_txns do
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

    total =
      Enum.reject(net_rev, fn {key, _} -> key == "" end)
      |> Enum.sort_by(&elem(&1, 1), &>=/2)
      |> Enum.take(3)
      |> generate_text_field()

    #   percent = calculate_percent(net_rev)

    # total =
    #   Enum.reject(percent, fn {key, _} -> key == "" end)
    #   |> Enum.sort_by(&elem(&1, 1), &>=/2)
    #   |> Enum.take(3)
    #   |> generate_text_field()
  end

  def calculate_percent(values) do
    total_sum = Map.values(values) |> Enum.sum()

    values
    |> Enum.map(fn {key, value} ->
      percentage = value / total_sum * 100
      {key, percentage}
    end)
    |> Map.new()
  end

  def generate_text_field(map) do
    formatted_pairs =
      Enum.map(map, fn {key, value} ->
        "• #{key}: #{value}"
      end)

    Enum.join(formatted_pairs, "\n")
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
end
