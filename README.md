# nvim-config

My personal Neovim setup. 

I got tired of having to manually install system dependencies like `ripgrep`, `fd`, Node, and Python virtualenvs on every new machine just to keep `:checkhealth` happy. To fix this, I wrapped the whole configuration in a Nix flake. It automatically bundles and isolates all the required binaries and language providers so it just works out of the box.

## How to run it

If you have [Nix installed](https://nixos.org/download) (with flakes enabled), you can spin up this exact environment anywhere instantly—no need to clone or install any global packages:

```bash
nix run github:CTRLRLTY/nvim-config/add-nix-flake
```

If you've already cloned the repo locally, just run:

```bash
nix run .
```

To run a health check and verify everything is working behind the scenes:
```bash
nix run . -- --headless "+checkhealth" +qa
```
