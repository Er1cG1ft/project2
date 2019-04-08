defmodule Project1.UserTokens.UserToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_tokens" do
    field :groupme_token, :string
    belongs_to :user, Project1.Users.User

    timestamps()
  end

  @doc false
  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, [:user_id, :groupme_token])
    |> validate_required([:user_id])
  end
end
