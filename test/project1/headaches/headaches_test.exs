defmodule Project1.HeadachesTest do
  use Project1.DataCase

  alias Project1.Headaches

  describe "headaches" do
    alias Project1.Headaches.Headache

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def headache_fixture(attrs \\ %{}) do
      {:ok, headache} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Headaches.create_headache()

      headache
    end

    test "list_headaches/0 returns all headaches" do
      headache = headache_fixture()
      assert Headaches.list_headaches() == [headache]
    end

    test "get_headache!/1 returns the headache with given id" do
      headache = headache_fixture()
      assert Headaches.get_headache!(headache.id) == headache
    end

    test "create_headache/1 with valid data creates a headache" do
      assert {:ok, %Headache{} = headache} = Headaches.create_headache(@valid_attrs)
    end

    test "create_headache/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Headaches.create_headache(@invalid_attrs)
    end

    test "update_headache/2 with valid data updates the headache" do
      headache = headache_fixture()
      assert {:ok, %Headache{} = headache} = Headaches.update_headache(headache, @update_attrs)
    end

    test "update_headache/2 with invalid data returns error changeset" do
      headache = headache_fixture()
      assert {:error, %Ecto.Changeset{}} = Headaches.update_headache(headache, @invalid_attrs)
      assert headache == Headaches.get_headache!(headache.id)
    end

    test "delete_headache/1 deletes the headache" do
      headache = headache_fixture()
      assert {:ok, %Headache{}} = Headaches.delete_headache(headache)
      assert_raise Ecto.NoResultsError, fn -> Headaches.get_headache!(headache.id) end
    end

    test "change_headache/1 returns a headache changeset" do
      headache = headache_fixture()
      assert %Ecto.Changeset{} = Headaches.change_headache(headache)
    end
  end
end
