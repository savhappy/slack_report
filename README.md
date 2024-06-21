# SlackReport

Welcome to my test project for Source Medium! I hope you enjoy playing with this project as much as I enjoyed creating it!

## **Getting Started**

### Install

```bash
git clone https://github.com/savhappy/slack_report.git
```

cd into slack_report and setup:

```elixir
mix setup
```

Setup Slack:

Copy this invitation and join this test slack group to see it in action:
  [slack_group](https://join.slack.com/t/testslackapp-world/shared_invite/zt-2l0oz1ena-WfasXx1Vi8k_9g9H1HHL~w)

and subscribe to this channel:
"daily_rev_reports"

After completing setup, you can start your application with: `iex -S mix` or `mix phx.server`

## **The Application**

When the application is running you can navigate to the Slack team/channel provided.

See screenshot with results:
![alttext](https://github.com/savhappy/slack_report/blob/main/assets/Screenshot%202024-06-21%20at%202.29.38%E2%80%AFPM.png)

## **Notes**

While this is very much a sample application, it mimics what a real SlackBot might provide for daily ecommerce reports

What I'm proud of:

- The functionality is scalable and can the data layer can be easily swapped out with an external API call to Shopify.
- Post to a real Slack group.
- Supervisor. I chose to start the process under a Supervision tree to allow extensibility for more reports.
- Polling Genserver to address time intervals.

Things I would add:

- Testing. This project was exciting but for timesake I've decided to present without tests additional tests. Before shipping to prod, extensive test should be added into the context and genserver.
- A very small amount of the formatting on the notification itself is off.
- Add a functioning `Share` button.
- The current GenServer is quite simple and doesn't efficiently handle any asynchronous tasks. This could be an issue for larger sets of data. 
- Create another table to access previpous report highlights. 

## Contact Me

If you have any additional questions, send an email to [Savannah Manning](mailto:sm05908@gmail.com@gmail.com).