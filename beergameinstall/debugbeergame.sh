#!/usr/bin/env bash
set -e

echo "==========================="
echo "🔎 Checking .NET SDK & Runtimes"
echo "==========================="
dotnet --list-sdks || echo "❌ Expected: .NET SDK 3.1.4xx (3.1.426)"
dotnet --list-runtimes || echo "❌ Expected: ASP.NET Core Runtime 3.1.x"
echo "✅ Expected: .NET SDK 3.1.4xx and ASP.NET Core 3.1 installed"
echo ""

echo "==========================="
echo "🔎 Checking environment variables"
echo "==========================="
echo "ASPNETCORE_ENVIRONMENT: ${ASPNETCORE_ENVIRONMENT:-Not set}"
echo "DOTNET_ENVIRONMENT: ${DOTNET_ENVIRONMENT:-Not set}"
if [[ "${ASPNETCORE_ENVIRONMENT}" != "Production" && "${ASPNETCORE_ENVIRONMENT}" != "Development" ]]; then
    echo "❌ Expected: ASPNETCORE_ENVIRONMENT set to 'Production' or 'Development'"
    echo "💡 Suggestion: export ASPNETCORE_ENVIRONMENT=Production"
fi
echo ""

echo "==========================="
echo "🔎 Checking SQL Server availability"
echo "==========================="
if command -v sqlcmd &> /dev/null; then
    if sqlcmd -S localhost -U sa -P 'B33rgam3' -Q "SELECT name FROM sys.databases;" | grep -q "BeerGameContext"; then
        echo "✅ BeerGameContext database found"
    else
        echo "❌ BeerGameContext database not found"
        echo "💡 Suggestion: Check your connection string and ensure database is created and migrated"
    fi
else
    echo "❌ sqlcmd not installed"
    echo "💡 Suggestion: apt install mssql-tools -y"
fi
echo ""

echo "==========================="
echo "🔎 Checking BeerGameContext tables"
echo "==========================="
if command -v sqlcmd &> /dev/null; then
    if sqlcmd -S localhost -U sa -P 'B33rgam3' -d BeerGameContext -Q "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;" | grep -q "Game"; then
        echo "✅ Tables exist in BeerGameContext"
    else
        echo "❌ No tables found in BeerGameContext"
        echo "💡 Suggestion: Apply EF migrations or ensure SeedData.Initialize() runs correctly"
    fi
fi
echo ""

echo "==========================="
echo "🔎 Checking running dotnet processes"
echo "==========================="
ps aux | grep '[d]otnet' || echo "❌ No dotnet processes running"
echo "✅ Expected: BlockchainDemonstratorApi.dll and BlockchainDemonstratorWebApp.dll processes"
echo ""

echo "==========================="
echo "🔎 Checking listening ports"
echo "==========================="
ss -tulpn | grep LISTEN || echo "❌ No listening ports found"
echo "✅ Expected: Ports 5000 (WebApp HTTP), 5001 (WebApp HTTPS), and 5002 (API)"
echo ""

echo "==========================="
echo "🔎 Checking curl to local services"
echo "==========================="
curl -I http://localhost:5000 || echo "❌ WebApp on port 5000 not responding"
curl -I http://localhost:5001 || echo "❌ WebApp on port 5001 not responding (try HTTPS configuration)"
curl -I http://localhost:5002 || echo "❌ API on port 5002 not responding"
echo "✅ Expected: HTTP/1.1 200 OK responses from all ports"
echo ""

echo "==========================="
echo "🔎 Checking API logs"
echo "==========================="
if [ -f ~/blockchain-demonstrator-serious-game/BlockchainDemonstratorApi/publish/api.log ]; then
    tail -n 20 ~/blockchain-demonstrator-serious-game/BlockchainDemonstratorApi/publish/api.log
else
    echo "❌ API log file not found"
    echo "💡 Suggestion: Check if API started successfully and correct publish folder is used"
fi
echo ""

echo "==========================="
echo "🔎 Checking WebApp logs"
echo "==========================="
if [ -f ~/blockchain-demonstrator-serious-game/BlockchainDemonstratorWebApp/publish/webapp.log ]; then
    tail -n 20 ~/blockchain-demonstrator-serious-game/BlockchainDemonstratorWebApp/publish/webapp.log
else
    echo "❌ WebApp log file not found"
    echo "💡 Suggestion: Check if WebApp started successfully and correct publish folder is used"
fi
echo ""

echo "==========================="
echo "✅ Debug checks finished"
echo "==========================="
echo "💡 If you see ❌ errors above, follow suggestions to fix them step by step."
