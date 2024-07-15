defmodule SlackReport do
  @moduledoc """
  API for Daily Reports.
  """

  alias SlackReport.Days.Body
  alias SlackReport.Days.Header

  @doc """
  Currently, this is attached to a real slack group:
  "https://join.slack.com/t/testslackapp-world/shared_invite/zt-2l0oz1ena-WfasXx1Vi8k_9g9H1HHL~w"
  copy this link to join the public slack and subscribe to the "daily_rev_reports" channel
  """

  @slack_webhook_url Application.compile_env(:slack_bot, :slack_webhook_url) ||
                       "https://hooks.slack.com/services/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"
  @set_date Application.compile_env(:slack_bot, :set_date) || ~D[2020-04-15]

  def send_daily_report(date \\ @set_date, channel \\ "general") do
    blocks = List.flatten([Header.build_block(date), Body.build_block(date)])

    post =
      Tesla.post!(
        @slack_webhook_url,
        %{
          channel: "##{channel}",
          username: "Jump",
          icon_emoji: ":desktop_computer:"
        }
        |> Map.merge(%{
          blocks: blocks
        })
        |> Jason.encode!()
      )

    case post.status do
      200 -> {:ok, post}
      status -> {:error, IO.puts("Notification not sent. Server responded with status #{status}")}
    end
  end
end
