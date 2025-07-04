#!/usr/bin/env bash
set -e

echo "========================"
echo "🛑 Stopping any running dotnet services..."
echo "========================"
if pgrep -f dotnet > /dev/null; then
  pkill -f dotnet
  echo "✅ Stopped running dotnet processes."
else
  echo "✅ No dotnet processes were running."
fi

echo "========================"
echo "🧹 Cleaning old publish folders..."
echo "========================"
rm -rf BlockchainDemonstratorApi/publish/*
rm -rf BlockchainDemonstratorWebApp/publish/*
echo "✅ Old publish folders cleared."

echo "========================"
echo "⚙️ Cleaning and building solution..."
echo "========================"
dotnet clean || { echo "❌ dotnet clean failed"; exit 1; }
dotnet build || { echo "❌ dotnet build failed"; exit 1; }

echo "========================"
echo "🚀 Publishing API..."
echo "========================"
cd BlockchainDemonstratorApi
dotnet publish -c Release -o ./publish || { echo "❌ API publish failed"; exit 1; }

echo "🔎 Checking API publish output..."
[ -f ./publish/BlockchainDemonstratorApi.dll ] && echo "✅ API DLL exists" || { echo "❌ API DLL missing"; exit 1; }
[ -f ./publish/appsettings.json ] && echo "✅ API appsettings.json exists" || echo "⚠️ API appsettings.json missing (check manually)"
cd ..

echo "========================"
echo "🚀 Publishing WebApp..."
echo "========================"
cd BlockchainDemonstratorWebApp
dotnet publish -c Release -o ./publish || { echo "❌ WebApp publish failed"; exit 1; }

echo "🔎 Checking WebApp publish output..."
[ -f ./publish/BlockchainDemonstratorWebApp.dll ] && echo "✅ WebApp DLL exists" || { echo "❌ WebApp DLL missing"; exit 1; }
[ -f ./publish/appsettings.json ] && echo "✅ WebApp appsettings.json exists" || echo "⚠️ WebApp appsettings.json missing (check manually)"
cd ..

echo "========================"
echo "🔎 Verifying SQL Server connectivity..."
echo "========================"
sqlcmd -S localhost -U sa -P 'B33rgam3' -Q "SELECT name FROM sys.databases;" || { echo "❌ SQL Server query failed"; exit 1; }

echo "========================"
echo "🔎 Checking ports (5000, 5001, 5002)..."
echo "========================"
for port in 5000 5001 5002; do
  if ss -tuln | grep -q ":$port"; then
    echo "⚠️ Port $port is already in use (check running services)"
  else
    echo "✅ Port $port is free"
  fi
done

echo "========================"
echo "✅ All checks passed. Preparation complete. Not started yet."
echo "========================"

echo "========================"
echo "📄 Overview summary:"
echo "========================"
echo "✔️ Old processes stopped and publish folders cleaned"
echo "✔️ Build completed successfully"
echo "✔️ API and WebApp published with DLLs verified"
echo "✔️ SQL Server reachable and responding"
echo "✔️ Ports checked: 5000, 5001, 5002 status printed"
echo "✔️ dotnet processes confirmed stopped before start"
echo "========================"
echo "⚠️ System ready to start manually or configure services."
echo "========================"
