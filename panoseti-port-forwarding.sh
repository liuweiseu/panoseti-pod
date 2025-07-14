#!/bin/bash

MINIKUBE_IP="192.168.49.2"

declare -A PORT_MAP=(
  [8086]=31002
  [3000]=31003
  [80]=31004
 )

enable_forwarding() {
    echo "[+] Enabling port forwarding to $MINIKUBE_IP"

    sudo sysctl -w net.ipv4.ip_forward=1 > /dev/null

    for HOST_PORT in "${!PORT_MAP[@]}"; do
        TARGET_PORT=${PORT_MAP[$HOST_PORT]}
        echo "  -> Forwarding host port $HOST_PORT to $MINIKUBE_IP:$TARGET_PORT"
        sudo iptables -t nat -A PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to-destination ${MINIKUBE_IP}:$TARGET_PORT
        sudo iptables -t nat -A POSTROUTING -p tcp -d ${MINIKUBE_IP} --dport $TARGET_PORT -j MASQUERADE
    done

    echo "[+] All rules added."
}

disable_forwarding() {
    echo "[+] Disabling port forwarding to $MINIKUBE_IP"

    for HOST_PORT in "${!PORT_MAP[@]}"; do
        TARGET_PORT=${PORT_MAP[$HOST_PORT]}
        echo "  -> Removing forwarding rule for host port $HOST_PORT to target port $TARGET_PORT"
        sudo iptables -t nat -D PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to-destination ${MINIKUBE_IP}:$TARGET_PORT
        sudo iptables -t nat -D POSTROUTING -p tcp -d ${MINIKUBE_IP} --dport $TARGET_PORT -j MASQUERADE
    done

    echo "[+] All rules removed."
}

case "$1" in
  on)
    enable_forwarding
    ;;
  off)
    disable_forwarding
    ;;
  *)
    echo "Usage: $0 {on|off}"
    exit 1
    ;;
esac
