let
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWYs+vS0rRamy642AnzwIhAzV3RPYQBz95CPeelHaeX";
  raserei = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGipGj7Ba+vWwTbFNCuKzcIns7CQYmA79CAtGSKp/WSk";
in {
  "eduroam.env.age".publicKeys = [nixos];
  "raserei-matetamasi-password.age".publicKeys = [raserei];
  "raserei-root-password.age".publicKeys = [raserei];
}
