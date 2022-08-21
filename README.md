# Ban Premium Stickers
![GitHub](https://img.shields.io/github/license/DomesticMoth/bps)
![Crates.io](https://img.shields.io/crates/v/bps)  
This bot allows you to prevent the usage of those cursed premium stickers in your telegram chat  
![Cursed](https://i.imgur.com/CRCg3rD.png)
## Configuration
Bot is controlling by the following environment variables  
### TELOXIDE_TOKEN
Telegram bot token received from [@BotFather](https://t.me/BotFather)
### RUST_LOG
Logging level  
It can take the following values
+ error
+ warn
+ info
+ debug
+ trace
### FOR_ALL_STICKERS
By default, bot reacts to premium stickers only,  
but you can also make it react to any stickers using `FOR_ALL_STICKERS=true`
### KICK_USERS
By default, bot only deletes messages with stickers,  
but you can also configure it to kick users who send them using `KICK_USERS=true`
## Instalation
### From source
```
git clone https://github.com/DomesticMoth/bps.git
cd bps
make build
make install
```
### With cargo install
```
cargo install bps
```
### NixOS flake
`flake.nix`
```nix
{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";

    bps.url = "path:/home/cofob/Documents/Dev/bps";
    bps.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, bps }:
    {
      nixosConfigurations = {
        example = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./example.nix
            bps.nixosModule
          ];
        };
      };
    };
}
```

`example.nix`
```nix
{ ... }:

{
    services.bps = {
        enable = true;
        tokenFile = "/path/to/token.env";
    };
}
```

`/path/to/token.env`
```
TELOXIDE_TOKEN=11111111:AAAAAAAAAAAAAAAAAAAAA
```
### Prebuild
You can download prebuilt binary or deb package from the [releases page](https://github.com/DomesticMoth/bps/releases/tag/v0.1.0)  
Hashes for v0.1.0  
+ bps-x64.deb sha256sum cf0246f9b1fde861c94853c0850a3ddf391517247b7dcd598f308497e259ed82
+ bps-x64-bin.gz sha256sum a60249f3eb7f7aabdbdbbbb38acdb86d306331ddf43cf18ee21a274016abaffd
