{config, pkgs, ...}:
{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = ''${pkgs.greetd.tuigreet}/bin/tuigreet \
          --remember \
          --time \
          --cmd \
          sway'';
        user = "greeter";
      };
      default_session = initial_session;
    };
  };
}
