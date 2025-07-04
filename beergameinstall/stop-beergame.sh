#!/bin/bash

echo "========================"
echo "🔎 Checking running dotnet processes..."
echo "========================"

# Find dotnet processes running your published DLLs
WEBAPP_PID=$(ps aux | grep 'dotnet BlockchainDemonstratorWebApp.dll' | grep -v grep | awk '{print $2}')
API_PID=$(ps aux | grep 'dotnet BlockchainDemonstratorApi.dll' | grep -v grep | awk '{print $2}')

if [[ -z "$WEBAPP_PID" && -z "$API_PID" ]]; then
  echo "✅ No Beergame services currently running."
  exit 0
fi

# Stop WebApp
if [[ -n "$WEBAPP_PID" ]]; then
  echo "🛑 Stopping WebApp (PID $WEBAPP_PID)..."
  kill "$WEBAPP_PID"
  sleep 2
  if ps -p "$WEBAPP_PID" > /dev/null; then
    echo "⚠️ WebApp did not stop gracefully — force killing..."
    kill -9 "$WEBAPP_PID"
  else
    echo "✅ WebApp stopped cleanly."
  fi
else
  echo "ℹ️ No WebApp process found."
fi

# Stop API
if [[ -n "$API_PID" ]]; then
  echo "🛑 Stopping API (PID $API_PID)..."
  kill "$API_PID"
  sleep 2
  if ps -p "$API_PID" > /dev/null; then
    echo "⚠️ API did not stop gracefully — force killing..."
    kill -9 "$API_PID"
  else
    echo "✅ API stopped cleanly."
  fi
else
  echo "ℹ️ No API process found."
fi

echo "========================"
echo "✅ All services stopped."
echo "========================"
