defmodule KinoPHP.ScriptCell do
  use Kino.JS
  use Kino.JS.Live
  use Kino.SmartCell, name: "PHP Script"

  @impl true
  def init(_attrs, ctx) do
    # How to set attributes:
    # ctx = assign(ctx,
    #   attr_1: Map.get(attrs, :attr_1, false),
    #   attr_2: Map.get(attrs, :attr_2, false)
    # )
    {:ok, ctx, editor: [
      attribute: "source",
      language: "php",
      placement: :bottom,
      default_source: "<?php\necho 'hello world';"
    ]}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{}, ctx}
  end

  @impl true
  def handle_event("update", %{}, ctx) do
    {:noreply, ctx}
  end

  @impl true
  def to_attrs(_ctx) do
    %{}
  end

  @impl true
  def to_source(attrs) do
    quote do
      frame = Kino.Frame.new() |> Kino.render()

      unquote(attrs["source"])
        |> KinoPHP.eval(fn output ->
          KinoPHP.append_to_frame(frame, output)
        end)

      Kino.nothing()
    end
      |> Kino.SmartCell.quoted_to_string()
  end

  asset "main.js" do
    """
    export function init(ctx, payload) {
      ctx.importCSS("main.css");

      ctx.root.innerHTML = `
        <div class="app">
          <div class="header">
            <form style="flex-grow:1;">
              <div class="header__title">
                <span>PHP Script</span>
              </div>
              <div style="flex-grow:1;"></div>
              <div>
                <!-- Actions -->
              </div>
            </form>
          </div>
        </div>
      `;

      ctx.handleSync(() => {
        // Synchronously invokes change listeners
        document.activeElement &&
        document.activeElement.dispatchEvent(new Event("change"));
      });
    }
    """
  end

  asset "main.css" do
    """
    .app {
      --gray-50: #f8fafc;
      --gray-100: #f0f5f9;
      --gray-200: #e1e8f0;
      --gray-300: #cad5e0;
      --gray-400: #91a4b7;
      --gray-500: #61758a;
      --gray-600: #445668;
      --gray-800: #1c2a3a;
      --yellow-100: #fff7ec;
      --yellow-600: #ffa83f;
      --blue-100: #ecf0ff;
      --blue-600: #3e64ff;
    }

    .header {
      display: flex;
      flex-wrap: wrap;
      align-items: stretch;
      justify-content: flex-start;
      background-color: var(--blue-100);
      padding: 8px 16px;
      border-left: solid 1px var(--gray-300);
      border-top: solid 1px var(--gray-300);
      border-right: solid 1px var(--gray-300);
      border-bottom: solid 1px var(--gray-200);
      border-radius: 0.5rem 0.5rem 0 0;
      gap: 16px;
    }

    .header__title {
      display: block;
      margin-bottom: 2px;
      font-size: 0.875rem;
      color: var(--gray-800);
      font-weight: 600;
    }
    """
  end
end
