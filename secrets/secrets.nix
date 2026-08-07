let
  keys = [
    # Macbook
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYcZUEMGwnRoAU6tkDXjV4NuDOm98ZUJO69pFCGT66i"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMph2ayaO20X6XnlqFICu+6VgmGKKw3WsK/30mkAbuGl odilf@macbookpro-1.home"

    # Nixbook
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHkQJf8Nu9cHGFbqKXxIYmXUbPSAINx3ip/CSvXovs+z root@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs7dVmctkkZn5gb+Vj0m9shYgtQYRJAPrKIyNk5gZ5A odilf@nixbook"

    # uoh-i
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDkZnSoBt8uod3RubvRQHNTM9Vo4ziO6EXKBQOp7gbfr root@uoh-i"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTTLv5PaFx+9oP9ge+Y5qaX3BIfUjqmegDAOoHVm8Bn odilf@uoh-i"

    # uoh-ii
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/rZwwQWHt8MBWPqaKM+RUzxcIKDkpVlWWvnCivckrZ root@uoh-ii"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSJoyt43qTodT9jic0ezm+P4BD6Hlab57NbDO/sxy+Y odilf@uoh-ii"
  ];
in
{
  "taskwarrior.age".publicKeys = keys;
  "ssh-host-shorthands.age".publicKeys = keys;
  "navidrome.age".publicKeys = keys;
  "radicale.age".publicKeys = keys;
  "immich-wallpapers-token.age".publicKeys = keys;
}
