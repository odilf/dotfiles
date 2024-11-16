Nix configurations

# Structure

Configuration is divided in hosts and modules. The entrypoint is `flake.nix` that mostly just sets up all the inputs and the modules and delegates doing the actual configuration to the corresponding host. 

The host configurations contain the high-level configuration of each machine. These configurations don't really delve into details because, again, they're high-level. More info in [hosts](./hosts/README.md).

The actual configuring of each pacakge is done in the `modules`, which are nixos (and home-manager? i'm not sure) modules. These should be platform and configuration agnostic with a sensible API. They should theoretically be able to be merged upstream except because they're very opinionated. More info in [modules](./modules/README.md). 
