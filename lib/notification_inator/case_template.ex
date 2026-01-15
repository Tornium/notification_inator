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
end
