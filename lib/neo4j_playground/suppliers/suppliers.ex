defmodule Neo4jPlayground.Suppliers do
  alias Neo4jPlayground.Neo4jAdapter
  alias Neo4jPlayground.Suppliers.Supplier

  @neo_repo Bolt.Sips

  def create(params) do
    case Supplier.changeset(%Supplier{}, params) do
      %{valid?: true} = cs ->
        query = "CREATE (supplier:Supplier #{build_supplier_params!(cs)}) RETURN supplier"

        Neo4jAdapter.run_query(query)

      _invalid = cs ->
        {:error, cs}
    end
  end

  def create_supplies_to(from_supplier, destination, type) do
    destination_type =
      case type do
        :supplier -> "Supplier"
        :company -> "Company"
      end

    query = """
      MATCH
        (from:Supplier),
        (to:#{destination_type})
      WHERE from.name = '#{from_supplier}' AND to.name = '#{destination}'
      CREATE (from)-[supplies_to:SUPPLIES_TO]->(to)
      RETURN supplies_to
    """

    Neo4jAdapter.run_query(query)
  end

  # for testing purposes
  def delete_all() do
    @neo_repo.query!(@neo_repo.conn, "MATCH (suppliers:Supplier) DELETE (suppliers)")
  end

  ###

  defp build_supplier_params!(%{changes: changes} = _cs) do
    raw_params =
      changes
      |> Enum.reduce("", fn {k, v}, acc ->
        acc <> "#{k}: '#{v}', "
      end)
      |> String.replace_suffix(", ", "")

    "{#{raw_params}}"
  end
end
