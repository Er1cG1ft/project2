defmodule Project1.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :pw_tries, :integer
    field :pw_last_try, :utc_datetime
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :admin, :password, :password_confirmation])
    |> validate_password(:password)
    |> validate_password(:password_confirmation)
    |> put_pass_hash()
    |> validate_required([:email, :first_name, :last_name, :password_hash])
  end
  
  # Password validation
  # From Comeonin docs
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def put_pass_hash(%Ecto.Changeset{
        valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  def put_pass_hash(changeset), do: changeset

  def valid_password?(password) when byte_size(password) > 3 do
    {:ok, password}
  end
  def valid_password?(_), do: {:error, "The password is too short"}
  
end
