{ 
  system.stateVersion = "25.05"; 
  wsl.enable = true; 
  wsl.defaultUser = "odilf";
  
  gui = false;
  custom.bundles.odilf = {
    development.enable = true;
  };
}
