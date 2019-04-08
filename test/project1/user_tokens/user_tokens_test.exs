defmodule Project1.UserTokensTest do
  use Project1.DataCase

  alias Project1.UserTokens

  describe "user_tokens" do
    alias Project1.UserTokens.UserToken

    @valid_attrs %{groupme_token: "some groupme_token"}
    @update_attrs %{groupme_token: "some updated groupme_token"}
    @invalid_attrs %{groupme_token: nil}

    def user_token_fixture(attrs \\ %{}) do
      {:ok, user_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserTokens.create_user_token()

      user_token
    end

    test "list_user_tokens/0 returns all user_tokens" do
      user_token = user_token_fixture()
      assert UserTokens.list_user_tokens() == [user_token]
    end

    test "get_user_token!/1 returns the user_token with given id" do
      user_token = user_token_fixture()
      assert UserTokens.get_user_token!(user_token.id) == user_token
    end

    test "create_user_token/1 with valid data creates a user_token" do
      assert {:ok, %UserToken{} = user_token} = UserTokens.create_user_token(@valid_attrs)
      assert user_token.groupme_token == "some groupme_token"
    end

    test "create_user_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserTokens.create_user_token(@invalid_attrs)
    end

    test "update_user_token/2 with valid data updates the user_token" do
      user_token = user_token_fixture()
      assert {:ok, %UserToken{} = user_token} = UserTokens.update_user_token(user_token, @update_attrs)
      assert user_token.groupme_token == "some updated groupme_token"
    end

    test "update_user_token/2 with invalid data returns error changeset" do
      user_token = user_token_fixture()
      assert {:error, %Ecto.Changeset{}} = UserTokens.update_user_token(user_token, @invalid_attrs)
      assert user_token == UserTokens.get_user_token!(user_token.id)
    end

    test "delete_user_token/1 deletes the user_token" do
      user_token = user_token_fixture()
      assert {:ok, %UserToken{}} = UserTokens.delete_user_token(user_token)
      assert_raise Ecto.NoResultsError, fn -> UserTokens.get_user_token!(user_token.id) end
    end

    test "change_user_token/1 returns a user_token changeset" do
      user_token = user_token_fixture()
      assert %Ecto.Changeset{} = UserTokens.change_user_token(user_token)
    end
  end
end
