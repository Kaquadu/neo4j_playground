defmodule Neo4jPlayground.Suppliers.Supplier do
  use Neo4jPlayground.Schema

  @cast_fiels ~w(name country city zip_code street number)a
  @required_fields ~w(name country)a

  schema "suppliers" do
    field(:name, :string)
    field(:country, :string)
    field(:city, :string)
    field(:zip_code, :string)
    field(:street, :string)
    field(:number, :string)
  end

  def changeset(company, attrs \\ %{}) do
    company
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
