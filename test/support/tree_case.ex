defmodule WitchcraftersPlay.TreeCase  do

  use ExUnit.CaseTemplate

  alias WitchcraftersPlay.Tree23

  def check_tree_keys(%Tree23.Empty{}) do
    {:ok, nil}
  end

  def check_tree_keys(%Tree23.Leaf{key: key}) do
    {:ok, key}
  end

  def check_tree_keys(node = %Tree23.Node2{left: left, right: right, lower_key: lk, max_right_key: mrk}) do
    with {:ok, left_max_key} <- check_tree_keys(left),
         {:ok, right_max_key} <- check_tree_keys(right)
    do
      if(left_max_key <= lk && right_max_key <= mrk && left_max_key < right_max_key) do
        {:ok, right_max_key}
      else
        {:error, node}
      end
    end
  end

  def check_tree_keys(node = %Tree23.Node3{left: left, middle: middle, right: right, lower_key: lk, upper_key: uk, max_right_key: mrk}) do
    with {:ok, left_max_key} <- check_tree_keys(left),
    {:ok, middle_max_key} <- check_tree_keys(middle),
         {:ok, right_max_key} <- check_tree_keys(right)
    do
      if(left_max_key <= lk && middle_max_key <= uk && right_max_key <= mrk && left_max_key < middle_max_key && middle_max_key < right_max_key ) do
        {:ok, right_max_key}
      else
        {:error, node}
      end
    end
  end

  def check_tree_keys(node) do
    {:error, node}
  end
end
