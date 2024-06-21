defmodule SlackReport.Repo.Migrations.UpdateOrderDateType do
  use Ecto.Migration

  def change do
    alter table(:day_report) do
      remove :order_date
    end

    alter table(:day_report) do
      add :order_date, :date
    end
  end
end
