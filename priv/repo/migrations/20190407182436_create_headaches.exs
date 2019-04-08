defmodule Project1.Repo.Migrations.CreateHeadaches do
  use Ecto.Migration

  def change do
    create table(:headaches) do
      add :message, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :groupme_user, :string
      add :email, :string

      timestamps()
    end

    create index(:headaches, [:user_id])
  end
end
