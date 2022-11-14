defmodule Neo4jPlayground.SupplyChains do
  alias Neo4jPlayground.Neo4jAdapter

  def get_nth_degree_suppliers(base_name, n) do
    query = """
      MATCH (base {name: '#{base_name}'})<-[:SUPPLIES_TO*1..#{n}]-(supplier:Supplier) RETURN supplier.name
    """

    Neo4jAdapter.run_query(query)
  end

  def get_nth_degree_supply_chain(base_name, n) do
    query = """
      MATCH
        (base {name: '#{base_name}'})<-[supplies_tos:SUPPLIES_TO*1..#{n}]-(supplier:Supplier)
      UNWIND
        supplies_tos AS supplies_to
      WITH
        DISTINCT supplies_to
      RETURN
        startnode(supplies_to).name, endnode(supplies_to).name
    """

    Neo4jAdapter.run_query(query)
  end
end
