{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      programs.jujutsu = {
        settings = {
          user = {
            name = "odilf";
            email = "me@odilf.com";
          };

          ui = {
            default-command = "log";
            merge-editor = ":builtin";
            pager = "${pkgs.delta}/bin/delta";
          };

          revsets = {
            log = "present(@) | present(trunk()) | (mutable() & mine()) | parents(roots(mutable() & mine()))";
          };

          # from https://oppi.li/posts/configuring_jujutsu/
          templates = {
            log = ''
              if(root,
                format_root_commit(self),
                label(if(current_working_copy, "working_copy"),
                  separate(" ",
                    pad_end(4, format_short_change_id_with_change_offset(self)),
                    if(empty, label("empty", "(empty)")),
                    if(description,
                      description.first_line(),
                      label(if(empty, "empty"), description_placeholder),
                    ),
                    local_bookmarks,
                    tags,
                    working_copies,
                    if(conflict, label("conflict", "conflict")),
                    format_timestamp(commit_timestamp(self)),
                  ) ++ "\n"
                )
              )
            '';

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

          "format_timestamp(timestamp)" = "timestamp.ago()";

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

          git = {
            write-change-id-header = true;
          };
        };
      };
    }
  ];
}
