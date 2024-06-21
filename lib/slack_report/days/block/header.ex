defmodule SlackReport.Days.Header do
  @moduledoc """
  Header block for the Slack Message.
  """
  def build_block(date) do
    {:ok, formatted_date} = Timex.format(date, "{Mfull} {D}")

    [
      %{
        type: "section",
        text: %{
          type: "mrkdwn",
          text:
            "Here is yesterday's (#{formatted_date}) daily ecommerce report for www.myshop.com."
        }
      },
      %{
        type: "divider"
      },
      %{
        type: "section",
        text: %{
          type: "mrkdwn",
          text: ":moneybag: *Revenue:* `$59,327.02`"
        }
      },
      %{
        type: "context",
        elements: [
          %{
            type: "mrkdwn",
            text:
              ":white_check_mark: `+0.83%` vs *Prev. Day:*  `$58,833.22`\n:white_check_mark: `+63.36%` vs *Last Sunday:*  `$21,738.28`"
          }
        ]
      },
      %{
        type: "section",
        text: %{
          type: "mrkdwn",
          text: ":handshake: *Orders:*  `1,262`"
        }
      },
      %{
        type: "context",
        elements: [
          %{
            type: "mrkdwn",
            text:
              ":white_check_mark: `+5.47%` vs *Prev. Day:*  `1,193`\n:white_check_mark: `+66.96%` vs *Last Sunday:*  `417`"
          }
        ]
      },
      %{
        type: "section",
        text: %{
          type: "mrkdwn",
          text: ":shopping_bags:  *Avg. Order Value:* `$47.01`"
        }
      },
      %{
        type: "context",
        elements: [
          %{
            type: "mrkdwn",
            text:
              ":small_red_triangle_down: `-4.90%` vs *Prev. Day:*  `$49.32`\n:small_red_triangle_down: `-10.89%` vs *Last Sunday:*  `$52.13`"
          }
        ]
      },
      %{
        type: "section",
        text: %{
          type: "mrkdwn",
          text: ":money_with_wings: *Discounts:* `-$3,026.55`"
        }
      },
      %{
        type: "context",
        elements: [
          %{
            type: "mrkdwn",
            text:
              ":white_check_mark: `-13.48%` vs *Prev. Day:*  `-$3,434.45`\n:small_red_triangle_down: `+31.78%` vs *Last Sunday:*  `-$2,064.76`"
          }
        ]
      },
      %{
        type: "divider"
      },
      %{
        type: "section",
        text: %{
          type: "mrkdwn",
          text: "*Sales Breakdown (Top 3 by Revenue)*"
        }
      }
    ]
  end
end
