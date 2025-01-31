{
  lib,
  pkgs,
  config,
  ...
}:
{
  /*
    Expands `set` for each user's home config (i.e., `config.home-manager.<user>`)

    # Example

    ```nix
    {
      packages.users = [ "odilf" "gamer" ];

      config = eachHome {
        foo = "bar";
      };
    }
    ```

    Expands to:

    ```nix
    {
      config = home-manager.users = {
        odilf = {
          foo = "bar";
        };

        gamer = {
          foo = "bar";
        };
      };
    }
    ```
  */
  eachHome = set: {
    home-manager.users = builtins.listToAttrs (
      builtins.map (user: {
        name = user;
        value = set;
      }) config.packages.users
    );
  };

  # Like `eachHome`, except expands `set` for each user general NixOS config (i.e., `users.users.<user>`)
  eachUsers = set: {
    users.users = builtins.listToAttrs (
      builtins.map (user: {
        name = user;
        value = set;
      }) config.packages.users
    );
  };
}
