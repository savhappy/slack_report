defmodule SlackReport.Scheduler do
  @moduledoc """
  GenServer for scheduling daily reports
  """
  use GenServer

  @doc """
  This GenServer is responsible for sending a daily report based on when the GenServer is initialized.
  Currently we are passing in a default date/channel to send_daily_reports .
  """
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :schedule_report, calculate_time())
    {:ok, %{}, {:continue, :load_data}}
  end

  def handle_continue(:load_data, _state) do
    {:noreply, SlackReport.Days.send_daily_report()}
  end

  def handle_info(:schedule_report) do
    Process.send_after(self(), :update_time, 1000 * 60 * 60 * 24)
    {:noreply, SlackReport.Days.send_daily_report()}
  end

  def handle_info(:update_time) do
    Process.send_after(self(), :update_time, 1000 * 60 * 60 * 24)
    {:noreply, SlackReport.Days.send_daily_report()}
  end

  def calculate_time() do
    Time.diff(Time.utc_now(), ~T[11:00:00], :microsecond) |> abs()
  end
end
