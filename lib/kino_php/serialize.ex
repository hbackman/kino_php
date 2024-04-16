defmodule KinoPHP.Serialize do
  @moduledoc """
  Handles serialized PHP strings.

  ## Format

  Integer
  `i:value;`
  `i:256;`
  `i:-256;`

  Float
  todo

  Boolean
  `b:value;`
  `b:1;`
  `b:0;`

  String
  `s:size:value;`
  `s:3:"foo";`

  Null
  `N;`

  Array
  `a:size:{key, value;...}`
  `a:2:{i:0;b:1;i:1;b:0;}` (`[true, false]`)
  `a:2:{a:1:{i:0;i:0;};a:1{i:0;i:1;}}` (`[[0], [1]]`)

  Object
  `o:strlen(obj_name):obj_name:obj_size:{s:strlen(prop_name):"prop_name";prop_def}`
  `o:8:"stdClass":1:{s:3:"foo";s:3:"bar";}` (`stdClass` with `string $foo = "bar"`)
  """

  @doc """
  String:
    iex> KinoPHP.Serialize.unserialize!("s:3:\\"foo\\";")
    "foo"

    iex> KinoPHP.Serialize.unserialize!("s:11:\\"hello world\\";")
    "hello world"

  Boolean:
    iex> KinoPHP.Serialize.unserialize!("b:1;")
    true

    iex> KinoPHP.Serialize.unserialize!("b:0;")
    false

  Null:
    iex> KinoPHP.Serialize.unserialize!("N;")
    nil

  Integer:
    iex> KinoPHP.Serialize.unserialize!("i:256;")
    256

    iex> KinoPHP.Serialize.unserialize!("i:-256;")
    -256

  Float:
    iex> KinoPHP.Serialize.unserialize!("d:NAN;")
    :nan

    iex> KinoPHP.Serialize.unserialize!("d:INF;")
    :infinity

    iex> KinoPHP.Serialize.unserialize!("d:-INF;")
    :negative_infinity

    iex> KinoPHP.Serialize.unserialize!("d:25.5;")
    25.5

    iex> KinoPHP.Serialize.unserialize!("d:-12.001;")
    -12.001

  Array:
    iex> KinoPHP.Serialize.unserialize!("a:2:{i:0;i:1;i:1;i:2;};")
    [1, 2]

    iex> KinoPHP.Serialize.unserialize!("a:1:{s:3:\\"foo\\";s:3:\\"bar\\";};")
    %{"foo" => "bar"}
  """
  def unserialize!(value) do
    {value, _rest} = do_unserialize(value)
    value
  end

  def unserialize(value) do
    do_unserialize(value)
  end

  defp do_unserialize(""), do: nil

  defp do_unserialize("a:" <> rest) do
    # len is unused here at the moment.
    {_len, rest} = Integer.parse(rest)

    do_unserialize_array(rest)
  end

  defp do_unserialize("d:NAN;" <> rest),
    do: {:nan, rest}

  defp do_unserialize("d:INF;" <> rest),
    do: {:infinity, rest}

  defp do_unserialize("d:-INF;" <> rest),
    do: {:negative_infinity, rest}

  defp do_unserialize("d:" <> rest) do
    {value, rest} = Float.parse(rest)
    {value, trim_semicolon(rest)}
  end

  defp do_unserialize("i:" <> rest) do
    {value, rest} = Integer.parse(rest)
    {value, trim_semicolon(rest)}
  end

  defp do_unserialize("b:1;" <> rest),
    do: {true, rest}

  defp do_unserialize("b:0;" <> rest),
    do: {false, rest}

  defp do_unserialize("N;" <> rest),
    do: {nil, rest}

  defp do_unserialize("s:" <> rest) do
    {len, rest} = Integer.parse(rest)

    <<":\"", str::binary-size(len), "\"", rest::binary>> = rest

    {str, trim_semicolon(rest)}
  end

  # Array unserialization

  defp do_unserialize_array(string, acc \\ %{})

  defp do_unserialize_array(":{" <> rest, acc) do
    do_unserialize_array(rest, acc)
  end

  defp do_unserialize_array("}" <> rest, acc) do
    if php_array_is_list?(acc) do
      arr =
        acc
        |> Enum.to_list()
        |> Enum.map(&elem(&1, 1))

      {arr, trim_semicolon(rest)}
    else
      {acc, trim_semicolon(rest)}
    end
  end

  defp do_unserialize_array(part, acc) do
    {key, rest} = do_unserialize(part)
    {val, rest} = do_unserialize(rest)

    do_unserialize_array(rest, Map.put(acc, key, val))
  end

  defp php_array_is_list?(map) do
    Map.keys(map) == Enum.to_list(0..(map_size(map) - 1))
  end

  # Trim the semicolon from a remaining string.
  defp trim_semicolon(";" <> rest), do: rest

  defp trim_semicolon(rest), do: rest
end
