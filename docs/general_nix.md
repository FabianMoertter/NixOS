# Nix Commands

Rebuild system
```
sudo nixos-rebuild switch --flake .#
```

Rebuild home-manager
```
home-manager switch --flake .
```

List generations
```
nix-env --list-generations
```

List all generations
```
nix profile history --profile /nix/var/nix/profiles/system
```

Update channel
```
nix flake update
```

Delete generations
```
sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 14d
```

```
nix run nixpkgs#cowsay 'use package without creating a shell or installing it'
```

```
nix run --impure nixpkgs#spotify
```

