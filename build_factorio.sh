#!/bin/bash
built=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# if [$built -eq 0]; then
    apt update && apt upgrade -y
    echo -e "${BLUE}Creating user and group factorio${NC}"
    adduser --disabled-login -no-create-home --gecos factorio factorio
    echo -e "${BLUE}Attempted to create user ${NC}"
    cd /opt
    wget -O factorio_headless.tar.gz https://www.factorio.com/get-download/latest/headless/linux64
    tar -xvf factorio_headless.tar.gz
    rm factorio_headless.tar.gz
    echo -e "${BLUE}_________ \ngiving permissions to factorio user${NC}"
    chown -R factorio:factorio /opt/factorio

    echo -e "${BLUE}_________\n Making systemctl \n________ ${NC}"

    echo """
        [Unit]
        Description=Factorio Headless Server
        After=network.target

        [Service]
        User=factorio
        WorkingDirectory=/opt/factorio
        ExecStart=/opt/factorio/bin/x64/factorio --start-server /opt/factorio/saves/YourSaveFile.zip --server-settings /opt/factorio/data/server-settings.json
        Restart=on-failure

        [Install]
        WantedBy=multi-user.target
    """ > /etc/systemd/system/factorio.service

    systemctl enable factorio
    systemctl start factorio

    # TODO add custom server settings default
    echo -e "${BLUE}_________\n Adding basic config settings default PSWD ColdHarbourFile \n________ ${NC}"
    echo """
    {
  "name": "Game",
  "description": "Description",
  "tags": [ "game", "tags" ],

  "_comment_max_players": "Maximum number of players allowed, admins can join even a full server. 0 means unlimited.",
  "max_players": 0,

  "_comment_visibility": [
    "public: Game will be published on the official Factorio matching server",
    "lan: Game will be broadcast on LAN"
  ],
  "visibility": {
    "public": false,
    "lan": false
  },

  "_comment_credentials": "Your factorio.com login credentials. Required for games with visibility public",
  "username": "",
  "password": "",

  "_comment_token": "Authentication token. May be used instead of 'password' above.",
  "token": "",

  "game_password": "ColdHarbourFile",

  "_comment_require_user_verification": "When set to true, the server will only allow clients that have a valid Factorio.com account",
  "require_user_verification": false,

  "_comment_max_upload_in_kilobytes_per_second": "optional, default value is 0. 0 means unlimited.",
  "max_upload_in_kilobytes_per_second": 0,

  "_comment_max_upload_slots": "optional, default value is 5. 0 means unlimited.",
  "max_upload_slots": 5,

  "_comment_minimum_latency_in_ticks": "optional one tick is 16ms in default speed, default value is 0. 0 means no minimum.",
  "minimum_latency_in_ticks": 0,

  "_comment_max_heartbeats_per_second": "Network tick rate. Maximum rate game updates packets are sent at before bundling them together. Minimum value is 6, maximum value is 240.",
  "max_heartbeats_per_second": 60,

  "_comment_ignore_player_limit_for_returning_players": "Players that played on this map already can join even when the max player limit was reached.",
  "ignore_player_limit_for_returning_players": false,

  "_comment_allow_commands": "possible values are, true, false and admins-only",
  "allow_commands": "admins-only",

  "_comment_autosave_interval": "Autosave interval in minutes",
  "autosave_interval": 10,

  "_comment_autosave_slots": "server autosave slots, it is cycled through when the server autosaves.",
  "autosave_slots": 5,

  "_comment_afk_autokick_interval": "How many minutes until someone is kicked when doing nothing, 0 for never.",
  "afk_autokick_interval": 0,

  "_comment_auto_pause": "Whether should the server be paused when no players are present.",
  "auto_pause": true,

  "_comment_auto_pause_when_players_connect": "Whether should the server be paused when someone is connecting to the server.",
  "auto_pause_when_players_connect": false,

  "only_admins_can_pause_the_game": true,

  "_comment_autosave_only_on_server": "Whether autosaves should be saved only on server or also on all connected clients. Default is true.",
  "autosave_only_on_server": true,

  "_comment_non_blocking_saving": "Highly experimental feature, enable only at your own risk of losing your saves. On UNIX systems, server will fork itself to create an autosave. Autosaving on connected Windows clients will be disabled regardless of autosave_only_on_server option.",
  "non_blocking_saving": false,

  "_comment_segment_sizes": "Long network messages are split into segments that are sent over multiple ticks. Their size depends on the number of peers currently connected. Increasing the segment size will increase upload bandwidth requirement for the server and download bandwidth requirement for clients. This setting only affects server outbound messages. Changing these settings can have a negative impact on connection stability for some clients.",
  "minimum_segment_size": 25,
  "minimum_segment_size_peer_count": 20,
  "maximum_segment_size": 100,
  "maximum_segment_size_peer_count": 10
}
    """ > /opt/factorio/data/server-settings.json
# fi