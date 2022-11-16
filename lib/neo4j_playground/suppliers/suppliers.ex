defmodule Neo4jPlayground.Suppliers do
  alias Neo4jPlayground.Neo4jAdapter
  alias Neo4jPlayground.Suppliers.Supplier

  def get_suppliers() do
    query = """
      MATCH (suppliers:Supplier) RETURN suppliers
    """

    Neo4jAdapter.run_query(query)
  end

  def create(params) do
    case Supplier.changeset(%Supplier{}, params) do
      %{valid?: true} = cs ->
        query = "CREATE (supplier:Supplier #{build_supplier_params!(cs)}) RETURN supplier"

        Neo4jAdapter.run_query(query)

      _invalid = cs ->
        {:error, cs}
    end
  end

  def create_supplies_to(from_name, destination_name) do
    query = """
      MATCH
        (from),
        (to)
      WHERE from.name = '#{from_name}' AND to.name = '#{destination_name}'
      CREATE (from)-[supplies_to:SUPPLIES_TO]->(to)
      RETURN supplies_to
    """

    Neo4jAdapter.run_query(query)
  end

  # for testing purposes
  def delete_all() do
    Neo4jAdapter.run_query("MATCH (suppliers:Supplier) DETACH DELETE (suppliers)")
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
