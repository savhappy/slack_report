defmodule SlackReport.DaysTest do
  use SlackReport.DataCase, async: false
  alias SlackReport.Days
  alias SlackReport.Helpers

  describe "main context for day reports" do
    test "fetch_all_by_date/1 - returns all txns by given date" do
      Helpers.insert_data()
      assert length(Days.fetch_all_by_date(~D[2020-04-15])) == 6
    end

    test "calculate_total/2 - returns total for given type" do
      SlackReport.Helpers.insert_data()
      txns = Days.fetch_all_by_date(~D[2020-04-15])

      assert Days.calculate_total(txns, :order_type) == [
               {"non_subscription", 149.97, 71.43},
               {"subscription", 59.97, 28.57}
             ]
    end

    test "calculate_net_rev/1 - calculates the net rev and subtracts discounts" do
      grouped_txns = %{
        "non_subscription" => [
          %{
            gross_revenue: "49.99",
            discounts: "0"
          },
          %{
            gross_revenue: "49.99",
            discounts: "50"
          }
        ],
        "subscription" => [
          %{
            gross_revenue: "19.99",
            discounts: "0"
          },
          %{
            gross_revenue: "19.99",
            discounts: "9.99"
          }
        ]
      }

      assert %{"non_subscription" => 49.98, "subscription" => 29.99} ==
               Days.calculate_net_rev(grouped_txns)
    end

    test "calculate_percent/1 - calculates the percentage" do
      values = %{"non_subscription" => 49.98, "subscription" => 29.99}

      assert Days.calculate_percent(values) == %{
               "non_subscription" => 62.5,
               "subscription" => 37.5
             }
    end
  end
end
