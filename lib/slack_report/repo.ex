defmodule SlackReport.Repo do
  use Ecto.Repo,
    otp_app: :slack_report,
    adapter: Ecto.Adapters.Postgres
end
