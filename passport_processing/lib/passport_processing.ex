defmodule PassportProcessing do
  @doc ~S'''
      iex> input = """
      ...> ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      ...> byr:1937 iyr:2017 cid:147 hgt:183cm
      ...>
      ...> iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      ...> hcl:#cfa07d byr:1929
      ...>
      ...> hcl:#ae17e1 iyr:2013
      ...> eyr:2024
      ...> ecl:brn pid:760753108 byr:1931
      ...> hgt:179cm
      ...>
      ...> hcl:#cfa07d eyr:2025 pid:166559648
      ...> iyr:2011 ecl:brn hgt:59in
      ...> """
      ...> PassportProcessing.count_valid(input)
      2
  '''
  def count_valid(input) do
    input
    |> parse()
    |> Enum.count(&valid?/1)
  end

  defp parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_passport/1)
  end

  defp parse_passport(text) do
    text
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&parse_field/1)
    |> Enum.into(%{})
  end

  defp parse_field(field) do
    field
    |> String.split(":")
    |> List.to_tuple()
  end

  defp valid?(passport) do
    ~w[byr iyr eyr hgt hcl ecl pid] -- Map.keys(passport) == []
  end
end
