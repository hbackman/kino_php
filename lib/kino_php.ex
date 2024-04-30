defmodule KinoPHP do
  @doc """
  Executes a PHP script the result.
  """
  def eval(code, on_output) do
    # I can't get the code editor to highlight properly without using
    # "<?php" tag. So let's strip those before we evaluate.
    code = String.replace(code, "<?php", "")

    # check that its not nil
    exec = System.find_executable("php")

    port = Port.open({
      :spawn_executable, exec
    }, [
      :binary,
      :exit_status,
      :hide,
      :use_stdio,
      :stderr_to_stdout,
      args: [
        Application.app_dir(:kino_php, "priv/wrapper_eval.php"), code
      ],
      # Set the current directory to the same location as the livebook.
      cd: get_notebook_path!(),
    ])

    stream_output(port, on_output)
  end

  defp stream_output(port, on_output) do
    receive do
      {^port, {:data, data}} ->
        on_output.(data)

        stream_output(port, on_output)

      {^port, {:exit_status, status}} ->
        status

      {^port, {:exit_signal, signal}} ->
        signal

      {^port, {:error, reason}} ->
        raise reason
    end
  end

  @doc """
  Prints Terminal output into a Kino frame.

  ## Examples
  ```elixir
    frame = Kino.Frame.new() |> Kino.render()
    KinoPHP.append_to_frame(frame, "hello")
    KinoPHP.append_to_frame(frame, [:green, " world"])
  ```
  """
  def append_to_frame(frame, text) do
    text
      |> IO.ANSI.format()
      |> IO.iodata_to_binary()
      |> Kino.Text.new(terminal: true, chunk: true)
      |> then(&Kino.Frame.append(frame, &1))
  end

  def get_notebook_path!() do
    Kino.Bridge.get_evaluation_file()
      |> String.split("#")
      |> hd()
      |> Path.dirname()
  end
end
