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
      throw "This option should not be set in the current configuration. Are you missing a `mkIf isLinux/isDarwin`?";
  };

  fill-allow = lib.mkOption {
    description = ''
      Simillar to `fill`, except it is allowed to be set. This is certainly
      dirtier, and `fill` should be prefered.
    '';
    type = lib.types.anything;
  };
}
