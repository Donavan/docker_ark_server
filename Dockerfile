FROM jdonavan/steambase
MAINTAINER Donavan Stanley "<donavan.stanley@gmail.com>"

# Query port for Steam's server browser
EXPOSE  27015/udp

# Game client port
EXPOSE 7777/udp

# RCON for remote console server access
EXPOSE 32330

USER root
RUN echo "fs.file-max=100000" >>  /etc/sysctl.conf
RUN echo "* soft nofile 100000" >> /etc/security/limits.conf
RUN echo "* hard nofile 100000" >> /etc/security/limits.conf
RUN echo "session required pam_limits.so" >> /etc/pam.d/common-session

# From here on out we shouln't be root
USER steam

# Install the server
#RUN /home/steam/steamcmd/steamcmd.sh  +login anonymous +force_install_dir "/opt/steam/servers/ark" +app_update 376030 validate +quit
RUN /usr/local/bin/install_steam_app 376030 "/opt/steam/servers/ark"


# Use the save folder on our VOLUME
RUN ln -s  /opt/steam/save/ /opt/steam/servers/ark/ShooterGame/Saved

# We'll write the Ark version and a timestamp to the image so that we force everything below to be performed again each time we generate the file
RUN echo "Ark Version: 221.2 from Dockerfile generated at: 2015-10-30 20:49:20 -0400" /opt/steam/servers/ark_server_version.txt

# The first time a build is done this will be a no-op.  Following builds on the same host will just update the cached copy, saving a lot of time
RUN /usr/local/bin/install_steam_app 376030 "/opt/steam/servers/ark"

CMD ["/opt/steam/servers/ark/ShooterGame/Binaries/Linux/ShooterGameServer", "TheIsland?listen?bRawSockets", "-server" ,"-log", "-USEALLAVAILABLECORES"]
