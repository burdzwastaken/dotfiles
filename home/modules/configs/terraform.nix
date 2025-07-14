{ ... }:

{
  home.file.".terraformrc".text = ''
    provider_installation {
      dev_overrides {
          "forgerock.io/terraform/ema" = "/home/burdz/go/bin/"
      }

      # For all other providers, install them directly from their origin provider
      # registries as normal. If you omit this, Terraform will _only_ use
      # the dev_overrides block, and so no other providers will be available.
      direct {}
    }

    plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"
    disable_checkpoint = true
  '';
}
