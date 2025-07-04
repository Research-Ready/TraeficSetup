#!/bin/bash

DOMAIN="demonstrator.valuechainhackers.xyz"
DASHBOARD_PORT="8080"  # Adjust if your Traefik dashboard runs on a different port

echo "-------------------- Checking DNS resolution --------------------"
IP_DOMAIN=$(dig +short "$DOMAIN" | tail -n1)
if [ -z "$IP_DOMAIN" ]; then
    echo "❌ Domain $DOMAIN does not resolve!"
    exit 1
else
    echo "✅ Domain resolves to $IP_DOMAIN"
fi

echo ""
echo "-------------------- Checking main HTTP response --------------------"
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" http://$DOMAIN)

if [ "$HTTP_STATUS" == "200" ]; then
    echo "✅ Main page returns HTTP 200 OK."
else
    echo "⚠️ Main page HTTP status: $HTTP_STATUS (expected 200). Check routing or app status!"
fi

echo ""
echo "-------------------- Checking API path (if applicable) --------------------"
API_STATUS=$(curl -o /dev/null -s -w "%{http_code}" http://$DOMAIN/api/)

if [ "$API_STATUS" == "200" ]; then
    echo "✅ /api/ returns HTTP 200 OK."
else
    echo "⚠️ /api/ HTTP status: $API_STATUS (may not be configured or healthy)."
fi

echo ""
echo "-------------------- Checking port 5000 (backend, optional) --------------------"
nc -vz $DOMAIN 5000 &>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Port 5000 is open and reachable."
else
    echo "⚠️ Port 5000 is closed or filtered (expected if behind Traefik only)."
fi

echo ""
echo "-------------------- Checking port 5001 (backend, optional) --------------------"
nc -vz $DOMAIN 5001 &>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Port 5001 is open and reachable."
else
    echo "⚠️ Port 5001 is closed or filtered (expected if behind Traefik only)."
fi

echo ""
echo "-------------------- Checking Traefik dashboard --------------------"
DASHBOARD_STATUS=$(curl -o /dev/null -s -w "%{http_code}" http://$DOMAIN:$DASHBOARD_PORT/dashboard/)

if [ "$DASHBOARD_STATUS" == "200" ]; then
    echo "✅ Traefik dashboard reachable (HTTP 200 OK)."
else
    echo "⚠️ Traefik dashboard HTTP status: $DASHBOARD_STATUS (may be disabled or on another port)."
fi

echo ""
echo "-------------------- Final summary --------------------"
echo "✅ DNS resolves: $IP_DOMAIN"
echo "✅ Main page HTTP: $HTTP_STATUS"
echo "✅ /api/ path HTTP: $API_STATUS"
echo "✅ Backend ports checked"
echo "✅ Traefik dashboard checked"
echo ""
echo "🚦 All checks completed."
