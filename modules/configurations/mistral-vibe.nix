{ ... }: {

  home-manager.sharedModules = [
    ({ ... }: {
      programs.mistral-vibe.settings = {
        theme = "auto";
        active_model = "mistral-large-4";
        show_thinking_nodes = true;

        # Add ML4 until it's officially available
        models = [
          {
            name = "mistral-large-4-0";
            provider = "mistral";
            alias = "mistral-large-4";
            temperature = 0.2;
            input_price = 0.68;
            output_price = 2.09;
            cached_input_price = 0.07;
            thinking = "medium";
            supports_images = true;
            auto_compact_threshold = 900000;
          }
        ];
      };
    })
  ];
}
