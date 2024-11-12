defmodule GistCloneWeb.CreateGistLive do
  use GistCloneWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
