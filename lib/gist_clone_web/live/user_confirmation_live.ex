defmodule GistCloneWeb.UserConfirmationLive do
  use GistCloneWeb, :live_view

  alias GistClone.Accounts

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div class="em-gradient flex flex-col items-center justify-center">
      <h1 class="font-brand font-bold text-3xl text-white py-2">
        Confirm Account
      </h1>
    </div>
    <div class="mx-auto max-w-sm">
      <.form for={@form} id="confirmation_form" phx-submit="confirm_account">
        <.input field={@form[:token]} type="hidden" />
        <.button phx-disable-with="Confirming..." class="create_button w-full">
          Confirm my account
        </.button>
      </.form>

      <p class="text-center text-l font-brand font-bold text-white mt-4">
        <.link href={~p"/users/register"} class="text-emLavender-dark hover:underline">
          Register
        </.link>
        | <.link href={~p"/users/log_in"} class="text-emLavender-dark hover:underline">Log in</.link>
      </p>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User confirmed successfully.")
         |> redirect(to: ~p"/")}

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "User confirmation link is invalid or it has expired.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end
