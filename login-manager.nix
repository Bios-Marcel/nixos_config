{config, pkgs, ...}:
{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd sway";
	user = "marcel";
      };
      default_session = initial_session;
    };
  };
}
