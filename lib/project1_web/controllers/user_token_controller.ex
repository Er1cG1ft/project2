defmodule Project1Web.UserTokenController do
  use Project1Web, :controller

  alias Project1.UserTokens
  alias Project1.UserTokens.UserToken

  def index(conn, _params) do
    user_tokens = UserTokens.list_user_tokens()
    render(conn, "index.html", user_tokens: user_tokens)
  end

  def new(conn, _params) do
    changeset = UserTokens.change_user_token(%UserToken{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_token" => user_token_params}) do
    case UserTokens.create_user_token(user_token_params) do
      {:ok, user_token} ->
        conn
        |> put_flash(:info, "User token created successfully.")
        |> redirect(to: Routes.user_token_path(conn, :show, user_token))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_token = UserTokens.get_user_token!(id)
    render(conn, "show.html", user_token: user_token)
  end

  def edit(conn, %{"id" => id}) do
    user_token = UserTokens.get_user_token!(id)
    changeset = UserTokens.change_user_token(user_token)
    render(conn, "edit.html", user_token: user_token, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_token" => user_token_params}) do
    user_token = UserTokens.get_user_token!(id)

    case UserTokens.update_user_token(user_token, user_token_params) do
      {:ok, user_token} ->
        conn
        |> put_flash(:info, "User token updated successfully.")
        |> redirect(to: Routes.user_token_path(conn, :show, user_token))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_token: user_token, changeset: changeset)
    end
  end
  
  def reset_groupme(conn, %{"id" => id}) do
    user_token = UserTokens.get_user_token_by_user(conn.assigns.current_user.id)
    UserTokens.update_user_token(user_token, %{groupme_token: nil})
    conn
    |> put_flash(:info, "GroupMe successfully disabled.")
    |> redirect(to: Routes.page_path(conn, :setup))
  end

  def delete(conn, %{"id" => id}) do
    user_token = UserTokens.get_user_token!(id)
    {:ok, _user_token} = UserTokens.delete_user_token(user_token)

    conn
    |> put_flash(:info, "User token deleted successfully.")
    |> redirect(to: Routes.user_token_path(conn, :index))
  end
end
