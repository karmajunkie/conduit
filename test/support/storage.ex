defmodule Conduit.Storage do
  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    :ok = Application.stop(:conduit)
    :ok = Application.stop(:commanded)

    {:ok, _} = Application.ensure_all_started(:conduit)

    reset_readstore()
  end

  defp reset_eventstore do
    {:ok, conn} =
      EventStore.configuration()
      |> EventStore.Config.parse()
      |> EventStore.Config.default_postgrex_opts()
      |> Postgrex.start_link()
      
    EventStore.Storage.Initializer.reset!(conn)
  end

  defp reset_readstore do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Conduit.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Conduit.Repo, {:shared, self()})
  end

  defp truncate_readstore_tables do
"""
TRUNCATE TABLE
  accounts_users,
  blog_articles,
  blog_authors,
  blog_comments,
  blog_favorited_articles,
  blog_feed_articles,
  blog_tags,
  projection_versions
RESTART IDENTITY;
"""
  end
end
