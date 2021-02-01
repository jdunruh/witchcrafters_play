defmodule WitchcraftersPlayTest do
  use ExUnit.Case
  alias WitchcraftersPlay.Tree23
  doctest WitchcraftersPlay

  # helper function tests
  test "put_in for nested structs" do
    assert Tree23.struct_put_in(%Tree23.Node2{lower_key: 3, upper_key: 4, left: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
                                       right: %Tree23.Leaf{key: 4, value: "xyzzy"}}, [:left, :value], "Now is the time") ==
      %Tree23.Node2{lower_key: 3, upper_key: 4, left: %Tree23.Leaf{key: 3, value: "Now is the time"},
                    right: %Tree23.Leaf{key: 4, value: "xyzzy"}}
  end

  # Empty tree tests

  test "creates an empty tree" do
    assert Tree23.Empty.new() == %Tree23.Empty{}
  end

  test "inserts an element into an empty tree" do
    assert Tree23.insert(%Tree23.Empty{}, 3, %{a: 1, b: 2}) == %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}
  end

  # Leaf node tests

  test "inserts an element on the right for a tree consisting of a single leaf" do
    assert Tree23.insert(%Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}, 4, "xyzzy") ==
      %Tree23.Node2{lower_key: 3, upper_key: 4, left: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}, right: %Tree23.Leaf{key: 4, value: "xyzzy"}}
  end

  test "inserts an element on the left for a tree consisting of a single leaf" do
    assert Tree23.insert(%Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}, 2, "xyzzy") ==
      %Tree23.Node2{
        left: %Tree23.Leaf{key: 2, value: "xyzzy"},
        lower_key: 2,
        right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
        upper_key: 3
      }
  end
  test "updates an element in a tree consisting of a single leaf" do
    assert Tree23.insert(%Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}, 3, "xyzzy") ==
      %Tree23.Leaf{key: 3, value: "xyzzy"}
  end

  # Two child node with leaves as children tests (base case)

  test "left insert for two node" do
    assert Tree23.insert(%Tree23.Node2{
          left: %Tree23.Leaf{key: 2, value: "xyzzy"},
          lower_key: 2,
          right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
          upper_key: 3
      },
      1, "abcd") ==
      %Tree23.Node3{
        left: %Tree23.Leaf{key: 1, value: "abcd"},
        middle: %Tree23.Leaf{key: 2, value: "xyzzy"},
        lower_key: 1,
        right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
        upper_key: 2
      }
  end

  test "right insert for two node" do
    assert Tree23.insert(%Tree23.Node2{
          left: %Tree23.Leaf{key: 2, value: "xyzzy"},
          lower_key: 2,
          right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
          upper_key: 3
      },
      4, "abcd") ==
      %Tree23.Node3{
        left: %Tree23.Leaf{key: 2, value: "xyzzy"},
        middle: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
        lower_key: 2,
        right: %Tree23.Leaf{key: 4, value: "abcd"},
        upper_key: 3
      }
  end

  test "middle insert for two node" do
    assert Tree23.insert(%Tree23.Node2{
          left: %Tree23.Leaf{key: 1, value: "xyzzy"},
          lower_key: 1,
          right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
          upper_key: 3
},
      2, "abcd") ==
      %Tree23.Node3{
        left: %Tree23.Leaf{key: 1, value: "xyzzy"},
        middle: %Tree23.Leaf{key: 2, value: "abcd"},
        lower_key: 1,
        right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
        upper_key: 2
      }
  end

  test "right node value update" do
   assert Tree23.insert(%Tree23.Node2{
          left: %Tree23.Leaf{key: 1, value: "xyzzy"},
          lower_key: 1,
          right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
          upper_key: 3
},
     3, "abcd") ==
      %Tree23.Node2{
            left: %Tree23.Leaf{key: 1, value: "xyzzy"},
            lower_key: 1,
            right: %Tree23.Leaf{key: 3, value: "abcd"},
            upper_key: 3
}
  end

        test "left node value update" do
          assert Tree23.insert(%Tree23.Node2{
                left: %Tree23.Leaf{key: 1, value: "xyzzy"},
                lower_key: 1,
                right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
                upper_key: 3
},
            1, "abcd") ==
            %Tree23.Node2{
                  left: %Tree23.Leaf{key: 1, value: "abcd"},
                  lower_key: 1,
                  right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
                  upper_key: 3
}
  end

  # Three child nodes with leaves (base case)
        test "left node insert for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4
},
            1, "Now is the time") ==
            %Tree23.Node4{
              left: %Tree23.Leaf{key: 1, value: "Now is the time"},
              lower_middle: %Tree23.Leaf{key: 2, value: "xyzzy"},
              upper_middle: %Tree23.Leaf{key: 4, value: "abcd"},
              lower_key: 1,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 4,
              middle_key: 2
            }
        end

        test "lower middle node insert for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4
},
            3, "Now is the time") ==
            %Tree23.Node4{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              lower_middle: %Tree23.Leaf{key: 3, value: "Now is the time"},
              upper_middle: %Tree23.Leaf{key: 4, value: "abcd"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 4,
              middle_key: 3
            }
        end

        test "upper middle node insert for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4
},
            5, "Now is the time") ==
            %Tree23.Node4{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              lower_middle: %Tree23.Leaf{key: 4, value: "abcd"},
              upper_middle: %Tree23.Leaf{key: 5, value: "Now is the time"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 5,
              middle_key: 4
            }
        end

        test "upper node insert for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4
},
            7, "Now is the time") ==
            %Tree23.Node4{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              lower_middle: %Tree23.Leaf{key: 4, value: "abcd"},
              upper_middle: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              lower_key: 2,
              right: %Tree23.Leaf{key: 7, value: "Now is the time"},
              upper_key: 6,
              middle_key: 4
            }
        end

        test "left node update for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4
},
            2, "Now is the time") ==
            %Tree23.Node3{
              left: %Tree23.Leaf{key: 2, value: "Now is the time"},
              middle: %Tree23.Leaf{key: 4, value: "abcd"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 4
            }
        end

        test "middle node update for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4
},
            4, "Now is the time") ==
            %Tree23.Node3{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              middle: %Tree23.Leaf{key: 4, value: "Now is the time"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 4
            }
        end

        test "right node update for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4
},
            6, "Now is the time") ==
            %Tree23.Node3{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              middle: %Tree23.Leaf{key: 4, value: "abcd"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: "Now is the time"},
              upper_key: 4
            }
        end

end
