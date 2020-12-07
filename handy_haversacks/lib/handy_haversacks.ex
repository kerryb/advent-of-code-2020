defmodule HandyHaversacks do
  @moduledoc """
  https://adventofcode.com/2020/day/7
  """

  @doc ~S'''
      iex> input = """
      ...> light red bags contain 1 bright white bag, 2 muted yellow bags.
      ...> dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      ...> bright white bags contain 1 shiny gold bag.
      ...> muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      ...> shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      ...> dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      ...> vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      ...> faded blue bags contain no other bags.
      ...> dotted black bags contain no other bags.
      ...> """
      ...> HandyHaversacks.count_possible_outer_bags(input)
      4
  '''
  def count_possible_outer_bags(input) do
    input
    |> parse()
    |> map_bags_to_possible_direct_containers()
    |> find_possible_outer_containers("shiny gold")
    |> Enum.count()
  end

  @doc ~S'''
      iex> input = """
      ...> light red bags contain 1 bright white bag, 2 muted yellow bags.
      ...> dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      ...> bright white bags contain 1 shiny gold bag.
      ...> muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      ...> shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      ...> dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      ...> vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      ...> faded blue bags contain no other bags.
      ...> dotted black bags contain no other bags.
      ...> """
      ...> HandyHaversacks.count_total_contained_bags(input)
      32
  '''
  def count_total_contained_bags(input) do
    input
    |> parse()
    |> count_contained_bags("shiny gold")
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.into(%{})
  end

  defp parse_line(line) do
    [bag] = Regex.run(~r/^(\w+ \w+)/, line, capture: :all_but_first)
    contents = Regex.scan(~r/(\d+) (\w+ \w+)/, line, capture: :all_but_first)

    {bag,
     Enum.map(contents, fn [count, description] -> {String.to_integer(count), description} end)}
  end

  defp map_bags_to_possible_direct_containers(rules) do
    Enum.reduce(
      rules,
      %{},
      fn {container, contents}, map -> add_to_map(map, container, contents) end
    )
  end

  defp add_to_map(map, container, contents) do
    Enum.reduce(contents, map, fn {_quantity, description}, acc ->
      Map.update(acc, description, MapSet.new([container]), &MapSet.put(&1, container))
    end)
  end

  defp find_possible_outer_containers(bags_to_containers, bag, result \\ MapSet.new()) do
    new = MapSet.difference(Map.get(bags_to_containers, bag, MapSet.new()), result)

    updated_result = MapSet.union(result, new)

    MapSet.union(
      updated_result,
      MapSet.new(
        Enum.flat_map(
          new,
          &find_possible_outer_containers(bags_to_containers, &1, updated_result)
        )
      )
    )
  end

  defp count_contained_bags(bags_to_contents, bag) do
    contents = bags_to_contents[bag]
    direct_count = contents |> Enum.map(fn {quantity, _description} -> quantity end) |> Enum.sum()

    indirect_count =
      contents
      |> Enum.map(fn {quantity, description} -> quantity * count_contained_bags(bags_to_contents, description) end)
      |> Enum.sum()

    direct_count + indirect_count
  end
end
