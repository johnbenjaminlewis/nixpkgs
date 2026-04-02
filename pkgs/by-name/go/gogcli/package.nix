{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "gogcli";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KtjqZLR4Uf77865IGHFmcjwpV8GWkiaV7fBeTrsx93E=";
  };

  vendorHash = "sha256-8RKzJq4nlg7ljPw+9mtiv0is6MeVtkMEiM2UUdKPP3U=";

  subPackages = [ "cmd/gog" ];

  # Committer date of tag v${version} (fixed per release for reproducible builds; update when bumping).
  gitCommitDate = "2026-03-09T05:52:34Z";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/steipete/gogcli/internal/cmd.version=v${finalAttrs.version}"
    "-X github.com/steipete/gogcli/internal/cmd.commit=${finalAttrs.src.rev}"
    "-X github.com/steipete/gogcli/internal/cmd.date=${finalAttrs.gitCommitDate}"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "gog --version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "CLI tool for interacting with Google APIs (Gmail, Calendar, Drive, and more)";
    homepage = "https://github.com/steipete/gogcli";
    changelog = "https://github.com/steipete/gogcli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "gog";
  };
})
