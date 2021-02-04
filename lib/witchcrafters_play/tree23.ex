defmodule WitchcraftersPlay.Tree23 do
  @moduledoc false

  import Algae
  use Witchcraft, except: [to_list: 1]
  alias WitchcraftersPlay.Tree23.{Empty, Node2, Node3, Node4, Leaf}

  defsum do
    defdata(Empty :: none())

    defdata Node1 do
      key :: any()
      node :: any()
    end

    defdata Node2 do
      lower_key :: any()
      max_right_key :: any()
      left :: Tree23.t() \\ Empty.new()
      right :: Tree23.t() \\ Empty.new()
    end

    defdata Node3 do
      lower_key :: any()
      upper_key :: any()
      max_right_key :: any()
      left :: Tree23.t() \\ Empty.new()
      middle :: Tree23.t() \\ Empty.new()
      right :: Tree23.t() \\ Empty.new()
    end

    defdata Node4 do
      lower_key :: any()
      middle_key :: any()
      upper_key :: any()
      max_right_key :: any()
      left :: Tree23.t() \\ Empty.new()
      lower_middle :: Tree23.t() \\ Empty.new()
      upper_middle :: Tree23.t() \\ Empty.new()
      right :: Tree23.t() \\ Empty.new()
    end

    defdata Leaf do
      key :: any()
      value :: any()
    end

  end

#  def new(), do: %Empty{}
#
#  @spec new(any(), any()) :: Node.t()
#  def new(key, value), do: %Leaf{key: key, value: value}
#
#  @spec new(any(), Node.t(), Node.t())
#  def new(lower_key, upper_key, left, right) do
#    %Node2{lower_key: lower_key, upper_key: upper_key, left: left, right: right}
#  end
#
#  @spec new(any(), Node.t(), Node.t(), Node.t())
#  def new(lower_key, upper_key, left, middle, right), do: %Node3{key: key, left: left, middle: right, right: right}
#
#  @spec new(any(), Node.t(), Node.t(), Node.t(), Node.t())
#  def new(lower_key, middle_key, upper_key, left, lower_middle, upper_middle, right) do
#    %Node4{key: key, left: left, lower_middle: lower_middle, upper_middle: upper_middle, right: right}
#  endinsert(left, orderable, value)

  #  @spec insert(t(), any()) :: t()

  def struct_put_in(struct, [key|[]], value) do
    Map.put(struct, key, value)
  end

  def struct_put_in(struct, [key|keys], new_value) do
    Map.put(struct, key, struct_put_in(Map.get(struct, key), keys, new_value))
  end

  def insert(%Empty{}, orderable, value), do: Leaf.new(orderable, value)

  def insert(tree = %Leaf{key: leaf_key, value: _value}, orderable, val) do
    case compare(orderable, leaf_key) do
      :equal -> %{tree | value: val }
      :greater -> Node2.new(leaf_key, orderable, tree, Leaf.new(orderable, val))
      :lesser -> Node2.new(orderable, leaf_key, Leaf.new(orderable, val), tree)
    end
  end

  def insert(tree = %Node2{lower_key: lower_key, max_right_key: max_right_key, left: %Leaf{} = left, right: %Leaf{} = right}, orderable, value) do
    case {compare(orderable, lower_key), compare(orderable, max_right_key)} do
      {:equal, _} -> struct_put_in(tree, [:left, :value], value)
      {_, :equal} -> struct_put_in(tree, [:right, :value], value)
      {:lesser, _} -> Node3.new(orderable, lower_key, right.key, Leaf.new(orderable, value), left, right)
      {_, :greater} -> Node3.new(lower_key, max_right_key, orderable, left, right, Leaf.new(orderable,value))
      _ -> Node3.new(lower_key, orderable, right.key, left, Leaf.new(orderable, value), right)
    end
  end

  def insert(tree = %Node3{lower_key: lower_key, upper_key: upper_key, max_right_key: max_right_key, left: %Leaf{} = left, middle: %Leaf{} = middle,
    right: %Leaf{} = right}, orderable, value) do
    case {compare(orderable, lower_key), compare(orderable, upper_key)} do
      {:equal, _} -> struct_put_in(tree, [:left, :value], value)
      {_, :equal} -> struct_put_in(tree, [:middle, :value], value)
      {:lesser, _} -> Node4.new(orderable, lower_key, upper_key, max_right_key, Leaf.new(orderable, value), left, middle, right)
      {:greater, :lesser} -> Node4.new(lower_key, orderable, upper_key, max_right_key, left, Leaf.new(orderable, value), middle, right)
      {_, :greater} -> case compare(orderable, right.key) do
                         :equal -> struct_put_in(tree, [:right, :value], value)
                         :greater -> Node4.new(lower_key, upper_key, right.key,  orderable, left, middle, right, Leaf.new(orderable, value))
                         :lesser -> Node4.new(lower_key, upper_key, orderable, max_right_key, left, middle, Leaf.new(orderable, value), right)
                       end
    end
  end

  def insert(tree = %Node2{lower_key: lower_key, max_right_key: max_right_key,  left: left, right: right}, orderable, value) do
    case compare(orderable, lower_key) do
      :lesser -> case new_node = insert(left, orderable, value) do
        %Node4{lower_key: lk, middle_key: mk, upper_key: uk, max_right_key: mrk, left: l,
          lower_middle: lm, upper_middle: um, right: r} ->
                     Node3.new(mk, mrk, max_right_key, Node2.new(lk, mk, l, lm), Node2.new(uk, mrk, um, r),
                       right)
                     _ -> Map.put(tree, :left, new_node)
        end
      :equal -> Map.put(tree, :left, insert(left, orderable, value))
      :greater -> case new_node = insert(right, orderable, value) do
          %Node4{lower_key: lk, middle_key: mk, upper_key: uk, max_right_key: mrk, left: l,
            lower_middle: lm, upper_middle: um, right: r} ->
            Node3.new(lower_key, mk, mrk, left, Node2.new(lk, mk, l, lm), Node2.new(uk, mrk, um, r))
          _ -> Map.put(tree, :right,  new_node) |> Map.put(:max_right_key, new_node.max_right_key)
          end
    end
  end

  def insert(
        tree = %Node3{lower_key: lower_key, upper_key: upper_key, left: left, middle: middle, right: right},
        orderable,
        value
      ) do
    case {compare(orderable, lower_key), compare(orderable, upper_key)} do
      {:lesser, _} -> case new_node = insert(left, orderable, value) do
                        %Node4{lower_key: lk, middle_key: mk, upper_key: uk, left: l,
                          lower_middle: lm, upper_middle: um, right: r} ->
                          Node4.new(lk, mk, Node2.new(lk, mk, l, lm), Node2.new(mk, uk, um, r), middle, right)
                        _ -> %{tree | left: new_node}
               end
      {:equal, _} -> %{tree | left: insert(left, orderable, value)}
      {:greater, :lesser} -> case new_node = insert(middle, orderable, value) do
                               %Node4{lower_key: lk, middle_key: mk, upper_key: uk, left: l,
                                 lower_middle: lm, upper_middle: um, right: r} ->
                                 Node4.new(mk, uk, left, Node2.new(lk, mk, l, lm), Node2.new(mk, uk, um, r), right)
                              _ -> %{tree | middle: new_node}
                               end
      {:greater, :equal} -> %{tree | right: insert(middle, orderable, value)}
      {:greater, :greater} -> case new_node = insert(right, orderable, value) do
                                %Node4{lower_key: lk, middle_key: mk, upper_key: uk, left: l,
                                  lower_middle: lm, upper_middle: um, right: r} ->
                                  Node4.new(mk, uk, left, middle, Node2.new(lk, mk, l, lm), Node2.new(mk, uk, um, r))
                                _ -> %{tree | right: new_node, max_right_key: new_node.max_right_key}
                              end
    end
  end

end
