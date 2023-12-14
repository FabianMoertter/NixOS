{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    thing1 = {
        thing2 = nixpkgs.legacyPackages.x86_64-linux.ripgrep;
      };

  };
}
