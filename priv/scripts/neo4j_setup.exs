{:ok, _neo} = Bolt.Sips.start_link(url: "bolt://neo4j:12345qwert@localhost")

conn = Bolt.Sips.conn()

unique_company_name_query = """
  CREATE CONSTRAINT unique_company_name_query IF NOT EXISTS
  FOR (company:Company)
  REQUIRE company.name IS UNIQUE
"""

Bolt.Sips.query!(conn, unique_company_name_query) |> IO.inspect()

unique_supplier_name_query = """
  CREATE CONSTRAINT unique_supplier_name_query IF NOT EXISTS
  FOR (supplier:Supplier)
  REQUIRE supplier.name IS UNIQUE
"""

Bolt.Sips.query!(conn, unique_supplier_name_query) |> IO.inspect()
