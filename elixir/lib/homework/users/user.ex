defmodule Homework.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  # arbitrary date to ensure our users are born before 18 years ago today
  @birthday_cutoff Date.utc_today |> Date.add(-18*365)

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:dob, :string)
    field(:first_name, :string)
    field(:last_name, :string)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :dob])
    |> validate_required([:first_name, :last_name, :dob])
    |> validate_date(:dob)
    |> validate_age(:dob)
    |> unique_constraint([:first_name, :last_name, :dob], name: :users_info_unique)
  end

  defp validate_date(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, date ->
      case Date.from_iso8601(date) do
        {:ok, _} -> []
        _ ->  [{field, options[:message] || "Invalid Date Provided"}]
      end
    end)
  end

  # for this to work better, I'd have converted the date to a DateTime, but am leaving it as a string
  # to save time.  So know I wouldn't be converting it both to check that it's valid
  # and is before the birthday_cutoff
  defp validate_age(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, date ->

      date = Date.from_iso8601!(date) # this is where I'd have made it a prop of the struct

      case Date.compare(@birthday_cutoff, date) do
        :gt -> []
        :eq -> []
        _ ->  [{field, options[:message] || "User does not meet age requirements"}]
      end
    end)
  end
end
