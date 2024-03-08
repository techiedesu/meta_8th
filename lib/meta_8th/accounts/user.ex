defmodule Meta8th.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :nickname, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true

    timestamps(type: :utc_datetime)
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:nickname, :password])
    |> validate_nickname(opts)
    |> validate_password(opts)
  end

  defp validate_nickname(changeset, opts) do
    changeset
    |> validate_required([:nickname])
    |> validate_format(:nickname, ~r/^[-\wA-Z\wА-я]{2,22}+$/,
      message: "разрешено от 2 до 22 знаков кирилицей, латиницей, - и _"
    )
    |> validate_length(:nickname, min: 2, max: 22)
    |> maybe_validate_unique_nickname(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 2, max: 72)
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Pbkdf2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_nickname(changeset, opts) do
    if Keyword.get(opts, :validate_nickname, true) do
      changeset
      |> unsafe_validate_unique(:nickname, Meta8th.Repo)
      |> unique_constraint(:nickname)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "ты опечатался в пароле")
    |> validate_password(opts)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Pbkdf2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Meta8th.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Pbkdf2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "старый пароль другой")
    end
  end
end
