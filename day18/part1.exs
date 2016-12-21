defmodule AdventOfCode18 do

  # Kind of silly up that this isn't in the Lists module...
  defp nth(i, [h|t]) do
    if i == 0, do: h, else: nth(i - 1, t)
  end


  defp get_at(i, row) do
    cond do
      i < 0 -> :safe
      i >= length(row) -> :safe
      true -> nth(i, row)
    end
  end


  defp tile_type_at(index, prev_row) do
    left = get_at(index - 1, prev_row)
    center = get_at(index, prev_row)
    right = get_at(index + 1, prev_row)

    cond do
      left == :trap and center == :trap and right == :safe -> :trap
      left == :safe and center == :trap and right == :trap -> :trap
      left == :trap and center == :safe and right == :safe -> :trap
      left == :safe and center == :safe and right == :trap -> :trap
      true -> :safe
    end
  end

  defp solve_recur(row, rowcount, total) do
    safes = for n <- row, fn x -> x == :safe end.(n), do: n
    newTotal = total + length(safes)
    if rowcount == 1 do
      newTotal
    else
      newRow = for n <- 0..(length(row) - 1), do: tile_type_at(n, row)
      solve_recur(newRow, rowcount - 1, newTotal)
    end
  end

  def solve(row, rowcount) do
    solve_recur(row, rowcount, 0)
  end
end


input = '.^^^^^.^^^..^^^^^...^.^..^^^.^^....^.^...^^^...^^^^..^...^...^^.^.^.......^..^^...^.^.^^..^^^^^...^.'
part_one_rows = 40
part_two_rows = 400000

as_atoms = Enum.map(input, fn x -> if x == List.first('.'), do: :safe, else: :trap end)
num_safes = AdventOfCode18.solve(as_atoms, part_one_rows)
IO.puts(num_safes)

more_safes = AdventOfCode18.solve(as_atoms, part_two_rows)
IO.puts(more_safes)
