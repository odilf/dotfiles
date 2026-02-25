let
  keys = [
    # Macbook
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYcZUEMGwnRoAU6tkDXjV4NuDOm98ZUJO69pFCGT66i"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMph2ayaO20X6XnlqFICu+6VgmGKKw3WsK/30mkAbuGl odilf@macbookpro-1.home"

    # Nixbook
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHkQJf8Nu9cHGFbqKXxIYmXUbPSAINx3ip/CSvXovs+z root@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs7dVmctkkZn5gb+Vj0m9shYgtQYRJAPrKIyNk5gZ5A odilf@nixbook"

    # From github
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfj3d1BRSRa7ddiKfZghyStS5UI3GomjGcAQZ5iEgMn"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMph2ayaO20X6XnlqFICu+6VgmGKKw3WsK/30mkAbuGl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSJoyt43qTodT9jic0ezm+P4BD6Hlab57NbDO/sxy+Y"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTTLv5PaFx+9oP9ge+Y5qaX3BIfUjqmegDAOoHVm8Bn"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJXTM2mTQPC/R6trDcSsuBOx+EDVPIXjetlZlBIVue4G"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlhCMpuwUa52+Pl0xRNwOMmWSUHIC5jfxo/L17jysO2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPagwX33BeD+sp5lPyXqm+X1+91Tw2o0ked7ngVvMvIL"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRtmfnqX+O+XErsStj/qRLYubAPUxbWJC6NEgAgwLSo"
  ];
in
{
  "taskwarrior.age".publicKeys = keys;
  "ssh-host-shorthands.age".publicKeys = keys;
  "navidrome.age".publicKeys = keys;
  "radicale.age".publicKeys = keys;
}
