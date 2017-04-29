defmodule Lkn.Core.Map do
  @typedoc """
  A key to identify and reach a Map.
  """
  @type k :: any

  defmacro defmap(name, do: block) do
    lines = case block do
              {:__block__, _, x} -> x
              x -> [x]
            end

    quote do
      defmodule unquote(name) do
        @after_compile __MODULE__

        unquote(lines)

        def components do
          @components
        end

        use Lkn.Core.Entity, components: @components

        def __after_compile__(_env, _bytecode) do
          # check if the components are effectively valid
          Enum.map(components(), fn cx ->
            c = Macro.expand(cx, __MODULE__)
            gold = c.specs().system().component(:map)

            if gold != c.specs() do
              raise "Module #{inspect c} implements #{inspect c.specs()} which is not the map component of #{inspect c.specs().system()}"
            end
          end)
        end
      end
    end
  end
end
