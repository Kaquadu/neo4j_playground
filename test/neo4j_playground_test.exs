defmodule Neo4jPlaygroundTest do
  use ExUnit.Case
  doctest Neo4jPlayground

  test "greets the world" do
    assert Neo4jPlayground.hello() == :world
  end
end
