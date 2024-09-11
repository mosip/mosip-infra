# Install GUI desktop on ubuntu

* Install `tightvncserver` & its dependency packages.
  ```
  $ sudo apt-get update
  $ sudo apt install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal ubuntu-desktop
  $ sudo apt-get install -y tightvncserver
  ```
* Setup `vncserver`.
  ```
  $ vncserver
    
    You will require a password to access your desktops.
    Password:
    Warning: password truncated to the length of 8.
    Verify:   
    Would you like to enter a view-only password (y/n)? n
    xauth:  file /home/ubuntu/.Xauthority does not exist
    
    New 'X' desktop is ip-172-31-13-234:1
    
    Creating default startup script /home/ubuntu/.vnc/xstartup
    Starting applications specified in /home/ubuntu/.vnc/xstartup
    Log file is /home/ubuntu/.vnc/ip-172-31-13-234:1.log
  ```
  ```
  $ vim ~/.vnc/xstartup
    
    #!/bin/sh
    export XKL_XMODMAP_DISABLE=1
    export XDG_CURRENT_DESKTOP="GNOME-Flashback:GNOME"
    export XDG_MENU_PREFIX="gnome-flashback-"
    gnome-session --session=gnome-flashback-metacity --disable-acceleration-check &
  ```
* Restart `vncserver` via below commands:
  ```
  $ vncserver -kill :1
  $ vncserver :1
  $ sudo reboot
  ```
* Ensure to expose tcp port `5901`.
* If the system undergoes a reboot, please execute the `vncserver :1` command to manually initiate the vncserver.
