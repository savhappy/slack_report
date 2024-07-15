# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SlackReport.Repo.insert!(%SlackReport.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

if Mix.env() == :test do
  txns = [
    %{
      order_date: ~D[2020-04-14],
      order_id: "4391013318831",
      customer_id: "6074436288683",
      source_medium: "paid_fb / cpc",
      gross_revenue: "49.99",
      discounts: "0",
      discount_codes: "",
      payment_gateway: "amazon_payments",
      order_type: "non_subscription"
    },
    %{
      order_date: ~D[2020-04-13],
      order_id: "4391013318832",
      customer_id: "6074436288682",
      source_medium: "paid_fb / cpc",
      gross_revenue: "49.99",
      discounts: "0",
      discount_codes: "",
      payment_gateway: "amazon_payments",
      order_type: "non_subscription"
    },
    %{
      order_date: ~D[2020-04-07],
      order_id: "4391013318833",
      customer_id: "6074436288681",
      source_medium: "paid_fb / cpc",
      gross_revenue: "49.99",
      discounts: "0",
      discount_codes: "",
      payment_gateway: "amazon_payments",
      order_type: "non_subscription"
    },
    %{
      order_date: ~D[2020-04-14],
      order_id: "1391013318831",
      customer_id: "4074436288683",
      source_medium: "paid_fb / cpc",
      gross_revenue: "19.99",
      discounts: "0",
      discount_codes: "",
      payment_gateway: "amazon_payments",
      order_type: "subscription"
    },
    %{
      order_date: ~D[2020-04-13],
      order_id: "2391013318832",
      customer_id: "3074436288682",
      source_medium: "paid_fb / cpc",
      gross_revenue: "19.99",
      discounts: "0",
      discount_codes: "",
      payment_gateway: "amazon_payments",
      order_type: "subscription"
    },
    %{
      order_date: ~D[2020-04-07],
      order_id: "3391013318833",
      customer_id: "2074436288681",
      source_medium: "paid_fb / cpc",
      gross_revenue: "19.99",
      discounts: "0",
      discount_codes: "",
      payment_gateway: "amazon_payments",
      order_type: "subscription"
    }
  ]

  SlackReport.Repo.insert_all(SlackReport.Day, txns)
end
