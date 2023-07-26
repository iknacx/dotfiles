{
  services.xserver = {
    libinput = {
      enable = true;
      touchpad = {
    	tapping = true;
    	tappingDragLock = true;
      naturalScrolling = true;
    	clickMethod = "buttonareas";
      };
    };
  };
}
