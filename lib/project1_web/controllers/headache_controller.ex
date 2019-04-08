defmodule Project1Web.HeadacheController do
  use Project1Web, :controller

  alias Project1.Headaches
  alias Project1.Headaches.Headache
  alias Project1.UserTokens

  def index(conn, _params) do
    headaches = Headaches.list_headaches()
    render(conn, "index.html", headaches: headaches)
  end

  def new(conn, _params) do
    changeset = Headaches.change_headache(%Headache{})
    token = UserTokens.get_user_token_by_user(conn.assigns.current_user.id)
    render(conn, "new.html", changeset: changeset, groupme_users: get_groupme_users(token), token: token)
  end
  
  def get_groupme_users(token) do
    if token.groupme_token != nil do
      resp = HTTPoison.get!("https://api.groupme.com/v3/chats?token=" <> token.groupme_token)
      data = Jason.decode!(resp.body)
      list = Enum.map(data["response"], & {&1["other_user"]["name"], &1["other_user"]["id"]})
    else 
      []
    end
  end

  def create(conn, %{"headache" => headache_params}) do
    token = UserTokens.get_user_token_by_user(conn.assigns.current_user.id)
    case Headaches.create_headache(headache_params) do
      {:ok, headache} ->
        data = %{direct_message: %{source_guid: "GUID", recipient_id: headache_params["groupme_user"], text: headache_params["message"]}}
        resp = HTTPoison.post!("https://api.groupme.com/v3/direct_messages?token=" <> token.groupme_token, Jason.encode!(data), [{"Content-Type", "application/json"}])
        Project1.Mailer.send_headache_text_email(%{email: headache_params["email"], message: headache_params["message"], first_name: conn.assigns.current_user.first_name, last_name: conn.assigns.current_user.last_name})
        conn
        |> put_flash(:info, "Headache created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
  
  def resend(conn, %{"id" => id}) do
    token = UserTokens.get_user_token_by_user(conn.assigns.current_user.id)
    headache = Headaches.get_headache!(id)
    data = %{direct_message: %{source_guid: "GUID", recipient_id: headache.groupme_user, text: headache.message}}
    resp = HTTPoison.post!("https://api.groupme.com/v3/direct_messages?token=" <> token.groupme_token, Jason.encode!(data), [{"Content-Type", "application/json"}])
    Project1.Mailer.send_headache_text_email(%{email: headache.email, message: headache.message, first_name: conn.assigns.current_user.first_name, last_name: conn.assigns.current_user.last_name})
    conn
    |> put_flash(:info, "Headache resent successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    headache = Headaches.get_headache!(id)
    render(conn, "show.html", headache: headache)
  end

  def edit(conn, %{"id" => id}) do
    headache = Headaches.get_headache!(id)
    changeset = Headaches.change_headache(headache)
    render(conn, "edit.html", headache: headache, changeset: changeset)
  end

  def update(conn, %{"id" => id, "headache" => headache_params}) do
    headache = Headaches.get_headache!(id)

    case Headaches.update_headache(headache, headache_params) do
      {:ok, headache} ->
        conn
        |> put_flash(:info, "Headache updated successfully.")
        |> redirect(to: Routes.headache_path(conn, :show, headache))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", headache: headache, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    headache = Headaches.get_headache!(id)
    {:ok, _headache} = Headaches.delete_headache(headache)

    conn
    |> put_flash(:info, "Headache deleted successfully.")
    |> redirect(to: Routes.headache_path(conn, :index))
  end
end
