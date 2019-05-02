defmodule Conduit.Blog.Workflows.Spoiler do
  use Commanded.Event.Handler,
  name: "Blog.Workflows.CreateAuthorFromUser"

  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Blog

  def init do
    Conduit.Repo.query!("select 1")
    :ok
  end

  
  def handle(%UserRegistered{user_uuid: user_uuid, username: username}, _metadata) do
    :ok
  end
end
