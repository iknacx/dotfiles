{ config, ... }: {
  time.timeZone = "America/Santiago";
  i18n.defaultLocale = "es_CL.UTF-8";
  console.keyMap = "dvorak-la";

  services.xserver = {
    layout = "latam";
    xkbVariant = "dvorak";
  };
}
