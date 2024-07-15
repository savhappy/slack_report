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
            text: "#{get_report(txns, :order_type, date) |> generate_text_field}"
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
            text: "#{get_report(txns, :source_medium, date) |> generate_text_field}"
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
            text: "#{get_report(txns, :discount_codes, date) |> generate_text_field}"
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
            text: "#{get_report(txns, :payment_gateway, date) |> generate_text_field}"
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

  def get_report(txns, type, _date) do
    result = Days.calculate_total(txns, type)
    result
  end

  defp generate_text_field(combined_list) do
    formatted_list =
      Enum.map(combined_list, fn {key, value, percentage} ->
        "• #{key}: #{value} (#{percentage}%)"
      end)

    Enum.join(formatted_list, "\n")
  end
end
