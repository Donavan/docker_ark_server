FROM jdonavan/steambase
MAINTAINER Donavan Stanley <donavan.stanley@gmail.com>

# Query port for Steam's server browser
EXPOSE  27015/udp 

# Game client port
EXPOSE 7777/udp

# RCON for remote console server access
EXPOSE 32330


# From here on out we shouln't be root
USER steam

# Install the server
RUN /home/steam/steamcmd/steamcmd.sh  +login anonymous +force_install_dir "/opt/steam/servers/ark" +app_update 376030 validate +quit
