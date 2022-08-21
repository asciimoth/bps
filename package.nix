{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "bps";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "DomesticMoth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-K3t1rcghph1JNaMFwwGoPuFKqfZRUGbYCDUEmNZxm18=";
  };

  cargoSha256 = "sha256-gq90jU6FQKwuZQ6pzleYEVSHTo7wECCLOFYkXCadAr0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "This bot allows you to prevent the usage of those cursed premium stickers in your telegram chat";
    homepage = "https://github.com/DomesticMoth/bps";
    license = licenses.agpl3;
  };
}
