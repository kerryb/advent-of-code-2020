defmodule PassportProcessing do
  @moduledoc """
  https://adventofcode.com/2020/day/4
  """

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
      ...> PassportProcessing.count_with_required_fields(input)
      2
  '''
  def count_with_required_fields(input) do
    input
    |> parse()
    |> Enum.count(&all_required_fields_present?/1)
  end

  @doc ~S'''
      iex> input = """
      ...> eyr:1972 cid:100
      ...> hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
      ...> 
      ...> iyr:2019
      ...> hcl:#602927 eyr:1967 hgt:170cm
      ...> ecl:grn pid:012533040 byr:1946
      ...> 
      ...> hcl:dab227 iyr:2012
      ...> ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
      ...> 
      ...> hgt:59cm ecl:zzz
      ...> eyr:2038 hcl:74454a iyr:2023
      ...> pid:3556412378 byr:2007
      ...> 
      ...> pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
      ...> hcl:#623a2f
      ...> 
      ...> eyr:2029 ecl:blu cid:129 byr:1989
      ...> iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
      ...> 
      ...> hcl:#888785
      ...> hgt:164cm byr:2001 iyr:2015 cid:88
      ...> pid:545766238 ecl:hzl
      ...> eyr:2022
      ...> 
      ...> iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
      ...> """
      ...> PassportProcessing.count_valid(input)
      4
  '''
  def count_valid(input) do
    input
    |> parse()
    |> Enum.filter(&all_required_fields_present?/1)
    |> Enum.count(&all_fields_valid?/1)
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

  defp all_required_fields_present?(passport) do
    ~w[byr iyr eyr hgt hcl ecl pid] -- Map.keys(passport) == []
  end

  defp all_fields_valid?(passport) do
    Enum.all?(passport, &field_valid?/1)
  end

  defp field_valid?({"byr", value}) do
    value =~ ~r/^\d{4}$/ and String.to_integer(value) in 1920..2002
  end

  defp field_valid?({"iyr", value}) do
    value =~ ~r/^\d{4}$/ and String.to_integer(value) in 2010..2020
  end

  defp field_valid?({"eyr", value}) do
    value =~ ~r/^\d{4}$/ and String.to_integer(value) in 2020..2030
  end

  defp field_valid?({"hgt", value}) do
    case Regex.run(~r/^(\d+)(in|cm)$/, value, capture: :all_but_first) do
      [height, "in"] -> String.to_integer(height) in 59..76
      [height, "cm"] -> String.to_integer(height) in 150..193
      _ -> false
    end
  end

  defp field_valid?({"hcl", value}) do
    value =~ ~r/^#[0-9a-f]{6}$/
  end

  defp field_valid?({"ecl", value}) do
    value in ~w[amb blu brn gry grn hzl oth]
  end

  defp field_valid?({"pid", value}) do
    value =~ ~r/^\d{9}$/
  end

  defp field_valid?(_field), do: true
end
