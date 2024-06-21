defmodule SlackReport.Repo.Migrations.ChangeDecimalsToStrings do
  use Ecto.Migration

  def change do
    alter table(:day_report) do
      remove :discounts
      remove :gross_revenue
    end

    alter table(:day_report) do
      add :discounts, :string
      add :gross_revenue, :string
    end
  end
end
