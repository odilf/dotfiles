{ config, ... }: {
  age.secrets.vpn.file = ../../secrets/vpn.age;

  networking.wg-quick.interfaces.surfshark = {
    configFile = "${config.age.secrets.vpn.path}";
    autostart = false;
  };
}
