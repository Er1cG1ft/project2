defmodule Project1.Headaches do
  @moduledoc """
  The Headaches context.
  """

  import Ecto.Query, warn: false
  alias Project1.Repo
  use Timex

  alias Project1.Headaches.Headache

  @doc """
  Returns the list of headaches.

  ## Examples

      iex> list_headaches()
      [%Headache{}, ...]

  """
  def list_headaches do
    Repo.all(Headache)
  end

  @doc """
  Gets a single headache.

  Raises `Ecto.NoResultsError` if the Headache does not exist.

  ## Examples

      iex> get_headache!(123)
      %Headache{}

      iex> get_headache!(456)
      ** (Ecto.NoResultsError)

  """
  def get_headache!(id), do: Repo.get!(Headache, id)

  @doc """
  Creates a headache.

  ## Examples

      iex> create_headache(%{field: value})
      {:ok, %Headache{}}

      iex> create_headache(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_headache(attrs \\ %{}) do
    %Headache{}
    |> Headache.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a headache.

  ## Examples

      iex> update_headache(headache, %{field: new_value})
      {:ok, %Headache{}}

      iex> update_headache(headache, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_headache(%Headache{} = headache, attrs) do
    headache
    |> Headache.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Headache.

  ## Examples

      iex> delete_headache(headache)
      {:ok, %Headache{}}

      iex> delete_headache(headache)
      {:error, %Ecto.Changeset{}}

  """
  def delete_headache(%Headache{} = headache) do
    Repo.delete(headache)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking headache changes.

  ## Examples

      iex> change_headache(headache)
      %Ecto.Changeset{source: %Headache{}}

  """
  def change_headache(%Headache{} = headache) do
    Headache.changeset(headache, %{})
  end
  
  def get_today_count do
    date = Timex.now
    Repo.one(from h in Headache, select: count("*"), where: h.inserted_at >= ^Timex.beginning_of_day(date), where: h.inserted_at <= ^Timex.end_of_day(date))
  end
  
  def get_this_week_count do
    date = Timex.now
    Repo.one(from h in Headache, select: count("*"), where: h.inserted_at >= ^Timex.beginning_of_week(date), where: h.inserted_at <= ^Timex.end_of_week(date))
  end
  
  def get_all_time_count do
    date = Timex.now
    Repo.one(from h in Headache, select: count("*"))
  end
end
