defmodule SlackReport.Days do
  @moduledoc """
  API for Daily Reports.
  """
  alias SlackReport.Days.Body
  alias SlackReport.Days.Header
  alias SlackReport.Repo

  import Ecto.Query

  @doc """
  Currently, this is attached to a real slack group:
  "https://join.slack.com/t/testslackapp-world/shared_invite/zt-2l0oz1ena-WfasXx1Vi8k_9g9H1HHL~w"
  copy this link to join the public slack and subscribe to the "daily_rev_reports" channel
  """

  @slack_webhook_url Application.compile_env(:slack_bot, :slack_webhook_url) ||
                       "https://hooks.slack.com/services/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"
  @set_date Application.compile_env(:slack_bot, :set_date) || ~D[2020-04-15]

  def send_daily_report(date \\ @set_date, channel \\ "daily_rev_reports") do
    blocks = List.flatten([Header.build_block(date), Body.build_block(date)])

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
  end

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
end
