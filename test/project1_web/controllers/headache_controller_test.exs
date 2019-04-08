defmodule Project1Web.HeadacheControllerTest do
  use Project1Web.ConnCase

  alias Project1.Headaches

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:headache) do
    {:ok, headache} = Headaches.create_headache(@create_attrs)
    headache
  end

  describe "index" do
    test "lists all headaches", %{conn: conn} do
      conn = get(conn, Routes.headache_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Headaches"
    end
  end

  describe "new headache" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.headache_path(conn, :new))
      assert html_response(conn, 200) =~ "New Headache"
    end
  end

  describe "create headache" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.headache_path(conn, :create), headache: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.headache_path(conn, :show, id)

      conn = get(conn, Routes.headache_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Headache"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.headache_path(conn, :create), headache: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Headache"
    end
  end

  describe "edit headache" do
    setup [:create_headache]

    test "renders form for editing chosen headache", %{conn: conn, headache: headache} do
      conn = get(conn, Routes.headache_path(conn, :edit, headache))
      assert html_response(conn, 200) =~ "Edit Headache"
    end
  end

  describe "update headache" do
    setup [:create_headache]

    test "redirects when data is valid", %{conn: conn, headache: headache} do
      conn = put(conn, Routes.headache_path(conn, :update, headache), headache: @update_attrs)
      assert redirected_to(conn) == Routes.headache_path(conn, :show, headache)

      conn = get(conn, Routes.headache_path(conn, :show, headache))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, headache: headache} do
      conn = put(conn, Routes.headache_path(conn, :update, headache), headache: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Headache"
    end
  end

  describe "delete headache" do
    setup [:create_headache]

    test "deletes chosen headache", %{conn: conn, headache: headache} do
      conn = delete(conn, Routes.headache_path(conn, :delete, headache))
      assert redirected_to(conn) == Routes.headache_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.headache_path(conn, :show, headache))
      end
    end
  end

  defp create_headache(_) do
    headache = fixture(:headache)
    {:ok, headache: headache}
  end
end
