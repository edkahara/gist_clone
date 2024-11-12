defmodule GistCloneWeb.PageController do
  use GistCloneWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: "/create")
  end
end
