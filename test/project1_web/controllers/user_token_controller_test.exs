defmodule Project1Web.UserTokenControllerTest do
  use Project1Web.ConnCase

  alias Project1.UserTokens

  @create_attrs %{groupme_token: "some groupme_token"}
  @update_attrs %{groupme_token: "some updated groupme_token"}
  @invalid_attrs %{groupme_token: nil}

  def fixture(:user_token) do
    {:ok, user_token} = UserTokens.create_user_token(@create_attrs)
    user_token
  end

  describe "index" do
    test "lists all user_tokens", %{conn: conn} do
      conn = get(conn, Routes.user_token_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing User tokens"
    end
  end

  describe "new user_token" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_token_path(conn, :new))
      assert html_response(conn, 200) =~ "New User token"
    end
  end

  describe "create user_token" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_token_path(conn, :create), user_token: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_token_path(conn, :show, id)

      conn = get(conn, Routes.user_token_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User token"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_token_path(conn, :create), user_token: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User token"
    end
  end

  describe "edit user_token" do
    setup [:create_user_token]

    test "renders form for editing chosen user_token", %{conn: conn, user_token: user_token} do
      conn = get(conn, Routes.user_token_path(conn, :edit, user_token))
      assert html_response(conn, 200) =~ "Edit User token"
    end
  end

  describe "update user_token" do
    setup [:create_user_token]

    test "redirects when data is valid", %{conn: conn, user_token: user_token} do
      conn = put(conn, Routes.user_token_path(conn, :update, user_token), user_token: @update_attrs)
      assert redirected_to(conn) == Routes.user_token_path(conn, :show, user_token)

      conn = get(conn, Routes.user_token_path(conn, :show, user_token))
      assert html_response(conn, 200) =~ "some updated groupme_token"
    end

    test "renders errors when data is invalid", %{conn: conn, user_token: user_token} do
      conn = put(conn, Routes.user_token_path(conn, :update, user_token), user_token: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User token"
    end
  end

  describe "delete user_token" do
    setup [:create_user_token]

    test "deletes chosen user_token", %{conn: conn, user_token: user_token} do
      conn = delete(conn, Routes.user_token_path(conn, :delete, user_token))
      assert redirected_to(conn) == Routes.user_token_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.user_token_path(conn, :show, user_token))
      end
    end
  end

  defp create_user_token(_) do
    user_token = fixture(:user_token)
    {:ok, user_token: user_token}
  end
end
