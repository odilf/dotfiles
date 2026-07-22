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

      # from https://oppi.li/posts/configuring_jujutsu/
      templates = {
        log = ''
          if(root,
            format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              concat(
                separate(" ",
                  pad_end(4, format_short_change_id_with_change_offset(self)),
                  if(empty, label("empty", "(empty)")),
                  if(description,
                    description.first_line(),
                    label(if(empty, "empty"), description_placeholder),
                  ),
                  bookmarks,
                  tags,
                  working_copies,
                  if(conflict, label("conflict", "conflict")),
                  if(config("ui.show-cryptographic-signatures").as_boolean(),
                    format_short_cryptographic_signature(signature)),
                  format_timestamp(commit_timestamp(self)),
                ) ++ "\n",
              ),
            )
          )
        '';
        #   if(root,
        #     format_root_commit(self),
        #     label(if(current_working_copy, "working_copy"),
        #       concat(
        #         separate(" ",
        #           format_short_change_id(self),
        #           if(empty, label("empty", "(empty)")),
        #           if(description,
        #             description.first_line(),
        #             label(if(empty, "empty"), description_placeholder),
        #           ),
        #           bookmarks,
        #           tags,
        #           working_copies,
        #           if(git_head, label("git_head", "HEAD")),
        #           if(conflict, label("conflict", "conflict")),
        #           if(config("ui.show-cryptographic-signatures").as_boolean(),
        #             format_short_cryptographic_signature(signature)),
        #         ) ++ "\n",
        #       ),
        #     )
        #   )
        # '';

        # Equivalent to git's `commit.verbose`
        draft_commit_description = ''
          concat(
            coalesce(description, default_commit_description, "\n"),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';
      };

      aliases = {
        l = [ "log" ];
        ll = [
          "log"
          "-r"
          ".."
        ];
        tug = [
          "bookmark"
          "move"
          "--from"
          "heads(::@- & bookmarks())"
          "--to"
          "@-"
        ];
      };
    };
  };
}
