defmodule Meta8th.Redix do
  alias Redix

  def child_spec(_args) do
    config = Application.get_env(:meta_8th, Meta8th.Redix)

    children = [
      {Redix, host: config[:host], database: config[:database], port: config[:port], name: :redix}
    ]

    %{
      id: RedixSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end

  def command(command) do
    Redix.command(:redix, command)
  end
end
