let
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWYs+vS0rRamy642AnzwIhAzV3RPYQBz95CPeelHaeX";
in {
  "eduroam.env.age".publicKeys = [system];
}
