defmodule SlackReport.Repo.Migrations.AddDayReportTable do
  use Ecto.Migration

  def change do
    create table(:day_report) do
      add :order_date, :date
      add :order_id, :string
      add :customer_id, :string
      add :source_medium, :string, null: true
      add :gross_revenue, :decimal
      add :discounts, :decimal
      add :discount_codes, :string, null: true
      add :payment_gateway, :string
      add :order_type, :string
    end

    create index(:day_report, :order_date)
  end
end
