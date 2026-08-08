{lib}: {
  mkWidgets = {
    output,
    positions,
  }: let
    login-box = "lockscreen-login-box@${output}";
    first = builtins.head positions;
    tail = builtins.tail positions;

    widgets =
      tail
      |> lib.imap1 (i: pos: {
        "lockscreen-widget-${lib.fixedWidthString 16 "0" (toString i)}" = {inherit output;} // pos;
      })
      |> lib.mergeAttrsList;
  in {
    widget_order = [login-box];
    widget =
      widgets
      // {
        ${login-box} = {inherit output;} // first;
      };
  };
}
