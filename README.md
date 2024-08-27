
```
 _ __ (_)_  __
| '_ \| \ \/ /
| | | | |>  < 
|_| |_|_/_/\_\
```

---


## Scripts

- radio stations aliases
- logout menu
- reminds (at backend)
- transfer (transfer.sh [down])
- show all `nb` tags

## Secrets

- tool: [git-crypt](https://github.com/AGWA/git-crypt)
- `cat ./secret-key-base64 | base64 -d > ./secret-key`
- `git-crypt unlock ./secret-key`

---

```bash
nix run nixpkgs#home-manager -- switch --flake .#"$USER"
```