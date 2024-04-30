# KinoPHP

Livebook smart cell for running PHP code. The goal for this project is to use
livebook for interactive documentation, while still being able to use other smart cells such as SQL.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `kino_php` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kino_php, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/kino_php>.

## Notes

https://www.theerlangelist.com/article/outside_elixir

## Goals

- [ ] Data serialization for PHP -> Elixir communication.
- [x] Detect composer autoloader.
- [ ] Detect laravel bootstrap.
- [ ] Figure out how to get php syntax highlighting without `<?php`.
