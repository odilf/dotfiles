{ ... }:
{
  home-manager.sharedModules = [
    {
      programs.iamb.settings = {
        default_profile = "user";
        profiles.user.user_id = "@odilf:matrix.org";
      };
    }
  ];
}
