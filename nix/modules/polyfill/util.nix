lib: {
  fill = lib.mkOption {
    description = ''
      This is a polyfill. It is used to not raise 'unknown options' 
      when having, for example, a `homebrew` attribute which gets 
      disabled for linux.

      Not intender for actual use.
    '';
    readOnly = true;
    apply =
      x:
      throw "This options should not be set in the current configuration. Are you missing a `mkIf isLinux/isDarwin`?";
  };
}
