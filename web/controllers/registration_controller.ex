defmodule Workshop.RegistrationController do
  use Workshop.Web, :controller

  alias Workshop.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params) # User is the model (business logic)
    Repo.insert(changeset) |> handle_create(conn)    # Repo is a generic repository (database operations)
  end

  # if operation is successful
  defp handle_create({:ok, user}, conn) do
    conn
    |> put_flash(:info, "User created")
    |> put_session(:current_user_id, user.id)
    |> redirect(to: page_path(conn, :index))
  end

  # if operation is not successful
  defp handle_create({:error, changeset}, conn) do
    conn
    |> render("new.html", changeset: changeset)
  end
end
