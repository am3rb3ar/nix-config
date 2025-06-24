{
  description = "am3rb3ar nixos and home-manager config";
  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:nix-community/home-manager/release5-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    inherit (self) outputs;
    stateVersion = "25.05";
    username = "dblum";
    laptopHostname = "nixos-inspiron";
    laptopSystem = "x86_64-linux";
    gitName = "am3rb3ar";
    gitEmail = "am3rb3ar@proton.me";
  in {
    nixosConfigurations = {
      ${laptopHostname} = let
        hostname = "${laptopHostname}";
	system = "${laptopSystem}";
        pkgs = import nixpkgs {
          inherit
	    system
	    inputs
	    outputs
	    ;
          # config = {
          #   allowUnfree = true;
          #   allowUnfreePredicate = _: true;
          # };
        };
        specialArgs = {
	  inherit
	    username
	    hostname
	    system
	    inputs
	    outputs
	    gitName
	    gitEmail
	    stateVersion
	    ;
	};
      in
        nixpkgs.lib.nixosSystem {
	  inherit 
	    specialArgs
	    ;
	  modules = [
	    ./configuration.nix
	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.${username} = import ./home.nix;
	      home-manager.extraSpecialArgs = inputs // specialArgs;
	    }
	  ];
	};
    };
  };
}
