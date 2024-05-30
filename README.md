# KinoPHP

Livebook smart cell for running PHP code. The goal for this project is to use
livebook for interactive documentation, while still keeping state similar to
how livebook normally executes cells.

## Installation

To bring KinoPHP to Livebook all you need to do is `Mix.install/2`:

```elixir
Mix.install([
  {:kino_php, "~> 0.2.0"}
])
```

## Goals

- [x] Detect composer autoloader.
- [x] Detect laravel bootstrap.
- [x] Colorized output.
- [ ] Data serialization for PHP -> Elixir communication.
- [ ] Figure out how to get php syntax highlighting without `<?php`.