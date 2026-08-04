{lib, ...}: let
  inherit (lib) optionalAttrs mergeAttrsList;

  mkUnit = {
    requires ? [],
    after ? [],
    wants ? [],
    config ? {},
  }:
    {
      inherit requires after wants;
    }
    // config;

  mkEnabled = {
    openFirewall ? true,
    group ? null,
    config ? {},
  }:
    {
      enable = true;
      inherit openFirewall;
    }
    // optionalAttrs (group != null) {inherit group;}
    // config;

  mkUnitWith = defaults: overrides:
    mkUnit {
      requires = (defaults.requires or []) ++ (overrides.requires or []);
      after = (defaults.after or []) ++ (overrides.after or []);
      wants = (defaults.wants or []) ++ (overrides.wants or []);
      config = defaults.config or {} // overrides.config or {};
    };
in {
  inherit mkUnit mkEnabled mkUnitWith;

  mkUnitAll = fn: names: config: mergeAttrsList (map (name: {${name} = fn config;}) names);
  mkEnabledAll = names: config: mergeAttrsList (map (name: {${name} = mkEnabled config;}) names);
}
