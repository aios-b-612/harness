---
name: investigate-host
description: >-
  Diagnostica hardware, rede e serviços neste notebook com shell antes de
  perguntar IP/protocolo. Use when the user asks if a device is reachable,
  RJ45/USB/Wi-Fi access, local ports, ADB, SSH, DHCP, or "consegue acessar".
metadata:
  opencode/slash: "true"
---

# investigate-host

Shell local neste host. Evidência primeiro.

## Fluxo

1. `ip -br addr` · `ip route` · estado das interfaces (`operstate` / carrier).
2. `ip neigh` — hosts já vistos; focar na interface do cabo/Wi‑Fi relevante.
3. Se houver compartilhamento NM (`10.42.0.1/24` em Ethernet): ping/scan leve nessa subnet.
4. No alvo: ping + portas comuns (`22`, `23`, `80`, `443`, `5555`, `8080`, `8008`).
5. Relatar tabela: interface, IP deste PC, IP/MAC alvo, RTT, portas abertas/fechadas.
6. Se L3 ok e zero serviços: dizer o que falta no aparelho (ex. ADB network) — não fingir shell remoto.

## Não fazer

- Pedir IP antes de olhar ARP/interfaces.
- Dizer que não há acesso a hardware local.
- Mudar firewall/rotas/firmware sem pedido explícito.
