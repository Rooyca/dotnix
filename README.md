
```
 _ __ (_)_  __
| '_ \| \ \/ /
| | | | |>  < 
|_| |_|_/_/\_\
```

---


## Scripts

- radio stations aliases (with mpd)
- logout menu
- reminds (at backend)
- transfer (transfer.sh [down])
- show all `nb` tags
- `timer` command
- tkinter dictionary that saves history

## Secrets

- tool: [git-crypt](https://github.com/AGWA/git-crypt)
- `git-crypt unlock ./sk`

---

```bash
nix run --extra-experimental-features nix-command --extra-experimental-features flakes nixpkgs#home-manager -- --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake .#"$USER"
sudo set-arch.sh
```
