defmodule Meta8th.Repo do
  use Ecto.Repo,
    otp_app: :meta_8th,
    adapter: Ecto.Adapters.Postgres
end
