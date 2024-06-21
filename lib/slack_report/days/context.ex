defmodule SlackReport.Days do
  alias SlackReport.Days.Body
  alias SlackReport.Repo

  import Ecto.Query

  @slack_webhook_url Application.compile_env(:slack_bot, :slack_webhook_url) ||
                       "https://hooks.slack.com/services/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"
  @set_date Application.compile_env(:slack_bot, :set_date) || ~D[2020-04-15]

  def send_daily_report(date \\ @set_date, channel \\ "daily_rev_reports") do
    Tesla.post!(
      @slack_webhook_url,
      %{
        channel: "##{channel}",
        username: "Jump",
        icon_emoji: ":desktop_computer:"
      }
      |> Map.merge(Body.build_block(date))
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
