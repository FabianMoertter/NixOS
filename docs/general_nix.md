```
nix run nixpkgs#cowsay 'use package without creating a shell or installing it'
```

```
nix run --impure nixpkgs#spotify
```

if home-manager error: 
```
Could not find suitable profile directory, tried /home/test/.local/state/home-manager/profiles and /nix/var/nix/profiles/per-user/test
```
do
```
nix profile list
```
