{
  description = "Application packaged using poetry2nix";

  inputs = { flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
        pkgs = nixpkgs.legacyPackages.${system};
        poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
        env = poetry2nix.mkPoetryEnv {
          projectDir = ./.;
          editablePackageSources = {
            my-app = ./src;
          };
          python = pkgs.python310;
          # preferWheels = true;
          overrides = poetry2nix.overrides.withDefaults (
            final: prev: {
              pyarrow = prev.pyarrow.override{
                preferWheel = true;
              };
              maturin = prev.maturin.overrideAttrs(old: {
                nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.cargo pkgs.rustc ];
              });
              jiter = prev.jiter.override {
                preferWheel = true;
              };
              tiktoken = prev.tiktoken.override {
                preferWheel = true;
              };
              langchain-openai = prev.langchain-openai.override {
                preferWheel = true;
              };
              benchmarks = prev.benchmarks.override {
                preferWheel = true;
              };
              ragas = prev.ragas.override {
                preferWheel = true;
              };
              pysbd = prev.pysbd.overridePythonAttrs(old: rec {
                preferWheel = true;
                postInstall = ''
                    echo "Cleaning up __pycache__ directories..."
                    rm -rf $out/lib/python3.10/site-packages/benchmarks

                    # Optionally call the old postInstall hook if it exists
                    ${old.postInstall or ""}
                '';
              });
            }
          );
        };

      in
      {
        devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.git
          pkgs.nodejs
          env
        ];

        shellHook = ''
          echo "Welcome to the development shell with Poetry!"
          export MY_ENV_VAR="value"
        '';
      };

        # Shell for poetry.
        #
        #     nix develop .#poetry
        #
        # Use this shell for changes to pyproject.toml and poetry.lock.
        devShells.poetry = pkgs.mkShell {
          packages = [ pkgs.poetry ];
        };
      });
}
