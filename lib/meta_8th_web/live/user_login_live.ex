defmodule Meta8thWeb.UserLoginLive do
  use Meta8thWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Вход
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:nickname]} type="text" label="Ник" required />
        <.input field={@form[:password]} type="password" label="Пароль" required />

        <:actions>
          <.button phx-disable-with="Минутку..." class="w-full">
            Войти <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    username = live_flash(socket.assigns.flash, :username)
    form = to_form(%{"nickname" => username}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
