{extensions, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
  (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "everforest";
          publisher = "sainnhe";
          version = "0.3.0";
          sha256 = "";
        }
        {
          name = "python";
          publisher = "ms-python";
          version = "2024.2.1";
          sha256 = "";
        }
        {
          name = "asm-code-lens";
          publisher = "maziac";
          version = "2.6.0";
          sha256 = "";
        }
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.3.1";
          sha256 = "";
        }
        {
          name = "liveserver";
          publisher = "ritwickdey";
          version = "5.7.9";
          sha256 = "";
        }
        {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "10.4.0";
          sha256 = "";
        }
        {
          name = "vscode-clangd";
          publisher = "llvm-vs-code-extensions";
          version = "0.1.28";
          sha256 = "";
        }
        {
          name = "codesnap";
          publisher = "adpyke";
          version = "";
          sha256 = "";
        }
        {
          name = "tabnine-vscode";
          publisher = "tabnine";
          version = "1.3.4";
          sha256 = "";
        }
        {
          name = "open-remote-ssh";
          publisher = "jeanp413";
          version = "0.0.45";
          sha256 = "";
        }
      ];
    })
  ];
}  
