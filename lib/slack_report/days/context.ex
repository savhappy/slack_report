defmodule SlackReport.Days do
  alias SlackReport.Days.Breakdown
  alias SlackReport.Repo

  import Ecto.Query

  @slack_webhook_url Application.compile_env(:slack_bot, :slack_webhook_url) ||
                       "https://hooks.slack.com/services/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"

  def send_daily_report(channel \\ "daily_rev_report") do
    Tesla.post!(
      @slack_webhook_url,
      %{
        channel: "##{channel}",
        username: "Jump",
        icon_emoji: ":desktop_computer:"
      }
      |> Map.merge(Breakdown.build_block())
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
