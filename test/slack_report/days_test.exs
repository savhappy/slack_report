defmodule SlackReport.DaysTest do
  use SlackReport.DataCase
  alias SlackReport.Days

  describe "core context functions" do
    test "fetch_all_by_date/1 - returns all txns by given date" do
      assert length(Days.fetch_all_by_date(~D[2020-04-15])) == 6
    end
  end
end
