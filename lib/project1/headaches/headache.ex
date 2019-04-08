defmodule Project1.Headaches.Headache do
  use Ecto.Schema
  import Ecto.Changeset

  schema "headaches" do
    field :message, :string
    belongs_to :user, Project1.Users.User
    field :groupme_user, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(headache, attrs) do
    headache
    |> cast(attrs, [:user_id, :message, :groupme_user, :email])
    |> validate_required([:user_id, :message])
  end
end
