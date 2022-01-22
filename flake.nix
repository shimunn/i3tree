{
  description = "A very basic flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.i3tree = {
    flake = false;
    url = "github:sciurus/i3tree";
  };

  outputs = { self, nixpkgs, flake-utils, i3tree }: (flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs {
      overlays = [ self.overlay ];
      inherit system;
    }; in
    rec {

      packages.i3tree = pkgs.i3tree;

      defaultPackage = packages.i3tree;

    })) // {
    overlay = final: prev: {
      i3tree = with final; runCommandLocal "i3tree" { nativeBuildInputs = [ makeWrapper ]; } ''
        makeWrapper ${i3tree}/i3tree $out/bin/i3tree \
           --prefix PATH : ${lib.makeBinPath [ (perl.withPackages(p: [p.AnyEventI3])) ]}
      '';
    };
  };
}
