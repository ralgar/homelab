# Renovate Bot (Optional)

This project provides automatic dependency updates using the Renovate bot.
 This dramatically reduces the maintenance burden of chores, allowing us to
 focus our efforts on more productive things instead.

Using the Renovate bot is optional, it only runs in scheduled pipelines.

---

## Enabling the Renovate bot

1. In the GitLab web UI, go to **Build >> Pipeline schedules**.

1. If no pipeline schedule exists, create one targeting the `main` branch.

Renovate will run on whatever schedule you define.

## Disabling the Renovate bot

1. In the GitLab web UI, go to **Build >> Pipeline schedules**.

1. Delete any pipeline schedules.

Renovate will no longer run in any pipelines.

## Configuring the Renovate bot

To configure the Renovate bot, simply edit the configuration file at
 `.gitlab/renovate.json`.
