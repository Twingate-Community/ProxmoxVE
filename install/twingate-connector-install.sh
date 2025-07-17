#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Author: [Andrew Baumbach]
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: [https://raw.githubusercontent.com/twingate-andrewb/ProxmoxVE] // TODO: change this

# Import Functions und Setup
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os


while true; do
  read -rp "Please enter your access token: " access_token
  if [[ -z "$access_token" ]]; then
    msg_error "Access token cannot be empty. Please try again."
  else
    break
  fi
done

while true; do
  read -rp "Please enter your refresh token: " refresh_token
  if [[ -z "$refresh_token" ]]; then
    msg_error "Refresh token cannot be empty. Please try again."
  else
    break
  fi
done

while true; do
  read -rp "Please enter your network name: " network
  if [[ -z "$network" ]]; then
    msg_error "Network cannot be empty. Please try again."
  else
    break
  fi
done

msg_info "Installing Twingate Connector"
export TWINGATE_ACCESS_TOKEN="${access_token}"
export TWINGATE_REFRESH_TOKEN="${refresh_token}"
export TWINGATE_NETWORK="${network}"
export TWINGATE_LABEL_DEPLOYED_BY="linux"
curl -fsSL "https://binaries.twingate.com/connector/setup.sh" | bash >> /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    msg_error "Failed to set up Twingate Connector. Please check your tokens and network name."
    exit 1
fi
msg_ok "Twingate Connector installed successfully!"

echo -e "${INFO}${YW} Twingate Connector status: $(systemctl status twingate-connector) ${CL}"

apt-get -y autoremove
apt-get -y autoclean

msg_info "If you need to update your access or refresh tokens, they can be found in /etc/twingate/connector.conf"
