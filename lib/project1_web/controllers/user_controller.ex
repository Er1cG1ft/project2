defmodule Project1Web.UserController do
  use Project1Web, :controller

  alias Project1.Users
  alias Project1.Users.User
  
  plug :authenticate_user when action not in [:new, :create]

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        if conn.assigns.current_user != nil do
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user))
        else
          conn
          |> put_flash(:info, "User created successfully.")
          |> put_session(:user_id, user.id)
          |> redirect(to: Routes.page_path(conn, :index))
        end
        

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
  
  def authenticate_user(conn, _params) do
    if conn.assigns.current_user != nil do
      conn
    else
      conn
      |> put_flash(:error, "Please log in to view this page.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
