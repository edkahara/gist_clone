defmodule GistCloneWeb.AllGistsLive do
  use GistCloneWeb, :live_view
  alias GistClone.Gists

  def mount(_params, _uri, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    gists = Gists.list_gists()

    socket =
      assign(socket,
        gists: gists
      )

    {:noreply, socket}
  end

  def gist(assigns) do
    ~H"""
    <div>
      <p class="text-white"><%= @current_user.email %>/<%= @gist.name %></p>
    </div>
    <div>
      <p class="text-white"><%= @gist.updated_at %></p>
    </div>
    <div>
      <p class="text-white"><%= @gist.description %></p>
    </div>
    <div>
      <p class="text-white"><%= @gist.markup_text %></p>
    </div>
    """
  end
end
