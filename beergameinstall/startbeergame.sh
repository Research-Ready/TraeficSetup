#!/usr/bin/env bash
set -e

API_PORT=5002
WEBAPP_HTTP_PORT=5000
WEBAPP_HTTPS_PORT=5001

API_LOG=~/blockchain-demonstrator-serious-game/BlockchainDemonstratorApi/publish/api.log
WEBAPP_LOG=~/blockchain-demonstrator-serious-game/BlockchainDemonstratorWebApp/publish/webapp.log

# Set environment to production to try and debug!
export ASPNETCORE_ENVIRONMENT=Production
export DOTNET_ENVIRONMENT=Production


echo "========================"
echo "▶️ Starting BlockchainDemonstratorApi..."
echo "========================"
cd ~/blockchain-demonstrator-serious-game/BlockchainDemonstratorApi/publish
nohup dotnet BlockchainDemonstratorApi.dll --urls "http://0.0.0.0:$API_PORT" > "$API_LOG" 2>&1 &

sleep 2

echo "========================"
echo "▶️ Starting BlockchainDemonstratorWebApp..."
echo "========================"
cd ~/blockchain-demonstrator-serious-game/BlockchainDemonstratorWebApp/publish
nohup dotnet BlockchainDemonstratorWebApp.dll --urls "http://0.0.0.0:$WEBAPP_HTTP_PORT;https://0.0.0.0:$WEBAPP_HTTPS_PORT" > "$WEBAPP_LOG" 2>&1 &

sleep 3

echo "========================"
echo "🔎 Checking environment..."
echo "========================"
echo "ASPNETCORE_ENVIRONMENT: ${ASPNETCORE_ENVIRONMENT:-Not set}"

echo "========================"
echo "🔎 Checking processes..."
echo "========================"
if pgrep -f "BlockchainDemonstratorApi.dll" > /dev/null; then
    echo "✅ API process is running"
else
    echo "❌ API process not found!"
fi

if pgrep -f "BlockchainDemonstratorWebApp.dll" > /dev/null; then
    echo "✅ WebApp process is running"
else
    echo "❌ WebApp process not found!"
fi

echo "========================"
echo "🔎 Checking listening ports..."
echo "========================"
ss -tulpn | grep ":$API_PORT" && echo "✅ API port $API_PORT is listening" || echo "❌ API port $API_PORT NOT listening"
ss -tulpn | grep ":$WEBAPP_HTTP_PORT" && echo "✅ WebApp HTTP port $WEBAPP_HTTP_PORT is listening" || echo "❌ WebApp HTTP port $WEBAPP_HTTP_PORT NOT listening"
ss -tulpn | grep ":$WEBAPP_HTTPS_PORT" && echo "✅ WebApp HTTPS port $WEBAPP_HTTPS_PORT is listening" || echo "⚠️  WebApp HTTPS port $WEBAPP_HTTPS_PORT may not be active yet"

echo "========================"
echo "✅ Startup checks finished"
echo "💡 Logs: $API_LOG and $WEBAPP_LOG"
echo "========================"
