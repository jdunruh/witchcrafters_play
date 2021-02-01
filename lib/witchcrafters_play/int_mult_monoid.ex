defmodule WitchcraftersPlay.IntMultMonoid do
   import Algae

  defdata any()

  @spec new(any()) :: t()
  def new(inner) do
    %WitchcraftersPlay.IntMultMonoid{intmultmonoid: inner}
  end

 defimpl TypeClass.Property.Generator, for: WitchcraftersPlay.IntMultMonoid do
    def generate(_) do
      [1, 2, 3, 0, -2]
      |> Enum.random()
      |> TypeClass.Property.Generator.generate()
      |> WitchcraftersPlay.IntMultMonoid.new()
    end
  end
end

import TypeClass
use Witchcraft

  ##########
  # Setoid #
  ##########

  definst Witchcraft.Setoid, for: WitchcraftersPlay.IntMultMonoid do
    def equivalent?(
          %{intmultmonoid: x},
          %{intmultmonoid: y}
        ) do
      x === y
    end
  end

  #######
  # Ord #
  #######

  definst Witchcraft.Ord, for: WitchcraftersPlay.IntMultMonoid do
    def compare(
          %WitchcraftersPlay.IntMultMonoid{intmultmonoid: int_a},
          %WitchcraftersPlay.IntMultMonoid{intmultmonoid: int_b}
        )
        when int_a === int_b,
        do: :equal

    def compare(
          %WitchcraftersPlay.IntMultMonoid{intmultmonoid: int_a},
          %WitchcraftersPlay.IntMultMonoid{intmultmonoid: int_b}
        )
        when Kernel.>(int_a, int_b),
        do: :greater

    def compare(
          %WitchcraftersPlay.IntMultMonoid{intmultmonoid: int_a},
          %WitchcraftersPlay.IntMultMonoid{intmultmonoid: int_b}
        )
        when Kernel.<(int_a, int_b),
        do: :lesser
  end

  definst Witchcraft.Semigroup, for: WitchcraftersPlay.IntMultMonoid do
    def append(
          %WitchcraftersPlay.IntMultMonoid{intmultmonoid: x},
          %WitchcraftersPlay.IntMultMonoid{intmultmonoid: y}
        ),
        do: %WitchcraftersPlay.IntMultMonoid{intmultmonoid: x * y}
  end

  ##########
  # Monoid #
  ##########

  definst Witchcraft.Monoid, for: WitchcraftersPlay.IntMultMonoid do
    def empty(_), do: %WitchcraftersPlay.IntMultMonoid{intmultmonoid: 1}
  end

