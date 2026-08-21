{lib}: {
  app-ids = list: rules: list |> map (app-id: {match.app_id = app-id;}) |> map (attrset: lib.mkMerge [attrset rules]);
}
