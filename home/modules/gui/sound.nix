{  ...  }:

{
  # Realtime
  # security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;

    pulse.enable = true; # Emulate PulseAudio
    alsa.enable = true;
  };
}
