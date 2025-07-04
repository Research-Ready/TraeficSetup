#!/usr/bin/env bash
set -e

echo "========================"
echo "🔎 Checking .NET SDK..."
echo "========================"
dotnet --list-sdks | grep 3.1

echo "========================"
echo "🔎 Checking ASP.NET Runtime..."
echo "========================"
dotnet --list-runtimes | grep "Microsoft.AspNetCore.App 3.1"

echo "========================"
echo "🔎 Checking SQL Server service..."
echo "========================"
systemctl is-active --quiet mssql-server && echo "SQL Server is running" || (echo "SQL Server is NOT running" && exit 1)

echo "========================"
echo "🔎 Checking SQL tools..."
echo "========================"
command -v sqlcmd >/dev/null 2>&1 && echo "sqlcmd is installed" || (echo "sqlcmd is NOT installed" && exit 1)

echo "========================"
echo "✅ All checks passed."
echo "========================"
