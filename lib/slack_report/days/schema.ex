defmodule SlackReport.Day do
  use Ecto.Schema
  import Ecto.Changeset

  schema "day_report" do
    field(:order_date, :date)
    field(:order_id, :string)
    field(:customer_id, :string)
    field(:source_medium, :string)
    field(:gross_revenue, :string)
    field(:discounts, :string)
    field(:discount_codes, :string)
    field(:payment_gateway, :string)
    field(:order_type, :string)
  end

  def example() do
    %{
      "customer_id" => "6106765328560",
      "discount_codes" => "",
      "discounts" => "0",
      "gross_revenue" => "49.99",
      "order_date" => "43936",
      "order_id" => "4423220461744",
      "order_type" => "non_subscription",
      "payment_gateway" => "shopify_payments",
      "source_medium" => "paid_fb / cpc"
    }
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [
      :order_date,
      :order_id,
      :customer_id,
      :source_medium,
      :gross_revenue,
      :discounts,
      :discount_codes,
      :payment_gateway,
      :order_type
    ])
    |> validate_required([
      :order_date,
      :order_id,
      :customer_id
    ])
  end
end
