defmodule Tornium.NotificationInator.CaseTemplate do
  use ExUnit.CaseTemplate
  require Logger

  @default_vm_state %{}

  setup_all do
    %{notification: ExUnit.configuration()[:notification]}
  end

  setup do
    lua_vm =
      @default_vm_state
      |> Tornium.Notification.Lua.setup_vm()
      |> Lua.load_api(Tornium.NotificationInator.API)

    %{vm: lua_vm}
  end

  using do
    quote do
      def generate_message(render_table) do
        render_state = Tornium.Utils.tuples_to_map(render_table)
        notification = ExUnit.configuration()[:notification]

        notification.message_template
        |> Solid.render!(render_state)
        |> Kernel.to_string()
        |> String.replace(["\n", "\t"], "")
        |> JSON.decode!()
      end
    end
  end
end
