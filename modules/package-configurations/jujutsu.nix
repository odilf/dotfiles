{ ... }:
{
  home-manager.users."*".programs.jujutsu = {
    settings = {
      user = {
        name = "odilf";
        email = "odysseas.maheras@gmail.com";
      };

      ui = {
        default-command = "log";
        merge-editor = ":builtin";
      };
    };
  };
}
