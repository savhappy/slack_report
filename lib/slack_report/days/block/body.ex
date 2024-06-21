defmodule SlackReport.Days.Body do
  @moduledoc """
  Body block for the Slack Message.
  """

  alias SlackReport.Days

  def build_block(date) do
    txns = Days.fetch_all_by_date(date)

    [
      %{
        type: "divider"
      },
      %{
        type: "section",
        text: %{
          type: "mrkdwn",
          text: "*Sales Body (Top 3 by Revenue)*"
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
      },
      %{
        type: "divider"
      },
      %{
        type: "actions",
        elements: [
          %{
            type: "button",
            text: %{
              type: "plain_text",
              text: ":hugging_face: Share Report",
              emoji: true
            },
            value: "share_report",
            action_id: "actionId-0"
          }
        ]
      },
      %{
        type: "section",
        text: %{
          type: "mrkdwn",
          text:
            ":speaking_head_in_silhouette: <https://www.sourcemedium.com/contact|*Give Feedback*>"
        }
      },
      %{
        type: "section",
        text: %{
          type: "mrkdwn",
          text:
            ":mag_right: Learn more about at <https://apps.shopify.com/sourcemedium|*SourceMedium.com*>"
        }
      }
    ]
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

    percent = calculate_percent(net_rev)

    percentage = take_top_three(percent)
    revenue = take_top_three(net_rev)

    combine(revenue, percentage) |> generate_text_field()
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

  defp generate_text_field(combined_list) do
    formatted_list =
      Enum.map(combined_list, fn {key, value, percentage} ->
        "• #{key}: #{value} (#{percentage}%)"
      end)

    Enum.join(formatted_list, "\n")
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
