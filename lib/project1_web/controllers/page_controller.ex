defmodule Project1Web.PageController do
  use Project1Web, :controller
  alias Project1.UserTokens
  alias Project1.Headaches

  def index(conn, _params) do
    render(conn, "index.html")
  end
  
  def setup(conn, _params) do
    token = UserTokens.get_user_token_by_user(conn.assigns.current_user.id)
    render(conn, "setup.html", token: token)
  end
  
  def groupme(conn, _params) do
    token = UserTokens.get_user_token_by_user(conn.assigns.current_user.id)
    UserTokens.update_user_token(token, %{groupme_token: _params["access_token"]})
    IO.inspect(_params)
    conn
      |> put_flash(:info, "GroupMe successfully enabled.")
      |> redirect(to: Routes.page_path(conn, :setup))
  end
  
  def stats(conn, _params) do
    render(conn, "stats.html", today: Headaches.get_today_count(), week: Headaches.get_this_week_count(), ever: Headaches.get_all_time_count())
  end
end
