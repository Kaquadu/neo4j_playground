defmodule Neo4jPlaygroundTest do
  use ExUnit.Case
  doctest Neo4jPlayground

  alias Neo4jPlayground.Companies
  alias Neo4jPlayground.Suppliers
  alias Neo4jPlayground.SupplyChains

  @tag timeout: :infinity
  test "Neo4j performance test" do
    Suppliers.delete_all()
    Companies.delete_all()

    company_name = "Company number #1"

    company_params = %{
      name: company_name,
      country: "Poland"
    }

    {:ok, _company} = Companies.create(company_params)

    create_nth_degree_graph(company_name, 4, 8)

    start = :os.system_time(:millisecond)
    assert {:ok, nodes} = Suppliers.get_suppliers()
    (:os.system_time(:millisecond) - start) |> IO.inspect(label: "Get All Suppliers")
    assert Enum.count(nodes) == 4094

    start = :os.system_time(:millisecond)
    assert {:ok, _nodes} = SupplyChains.get_nth_degree_suppliers("Company number #1", 1)
    (:os.system_time(:millisecond) - start) |> IO.inspect(label: "1st degree supply chain")

    start = :os.system_time(:millisecond)
    assert {:ok, _nodes} = SupplyChains.get_nth_degree_suppliers("Company number #1", 3)
    (:os.system_time(:millisecond) - start) |> IO.inspect(label: "3rd degree supply chain")

    start = :os.system_time(:millisecond)
    assert {:ok, _nodes} = SupplyChains.get_nth_degree_suppliers("Company number #1", 5)
    (:os.system_time(:millisecond) - start) |> IO.inspect(label: "5th degree supply chain")

    start = :os.system_time(:millisecond)
    assert {:ok, _nodes} = SupplyChains.get_nth_degree_suppliers("Company number #1", 8)
    (:os.system_time(:millisecond) - start) |> IO.inspect(label: "8th degree supply chain")
  end

  defp create_nth_degree_graph(parent_node_name, width, height) do
    do_create_nth_degree_graph(parent_node_name, width, 0, height)
  end

  defp do_create_nth_degree_graph(parent_node_name, width, current_height, height)
       when current_height == height do
    for _n <- 1..width do
      add_suppliers_layer!(parent_node_name)
    end
  end

  defp do_create_nth_degree_graph(parent_node_name, width, current_height, height) do
    for _n <- 1..width do
      supplier_name = add_suppliers_layer!(parent_node_name)

      do_create_nth_degree_graph(supplier_name, width, current_height + 1, height)
    end
  end

  defp add_suppliers_layer!(parent_node_name) do
    supplier_name = "Supplier #{Ecto.UUID.generate()}"

    supplier_params = %{
      name: supplier_name,
      country: "Poland"
    }

    {:ok, _supplier} = Suppliers.create(supplier_params)
    {:ok, _connection} = Suppliers.create_supplies_to(supplier_name, parent_node_name)

    supplier_name
  end
end
