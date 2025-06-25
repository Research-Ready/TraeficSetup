# ===================================================================
# Extensive Server & Website Health Checker (v2 - Compatible)
# ===================================================================

# --- Configuration ---
$Targets = @(
    "valuechainhackers.xyz",
    "hello.valuechainhackers.xyz"
)
$PublicIP = "94.142.241.156"
$CheckIntervalSeconds = 10

# --- Helper Function for Status Output ---
function Write-Status {
    param(
        [string]$CheckName,
        [bool]$Success,
        [string]$Message
    )
    $NameColumn = "  {0,-28}" -f $CheckName
    if ($Success) {
        Write-Host -NoNewline "$NameColumn : "
        Write-Host -ForegroundColor Green "PASS"
        Write-Host " - $Message"
    } else {
        Write-Host -NoNewline "$NameColumn : "
        Write-Host -ForegroundColor Red "FAIL"
        Write-Host " - $Message"
    }
}

# --- Main Loop ---
while ($true) {
    Clear-Host
    Write-Host "--- Starting Full Health Scan at $(Get-Date) ---"

    foreach ($TargetHost in $Targets) {
        Write-Host "`n[+] Checking Target: $TargetHost"
        Write-Host "--------------------------------------------------------"

        # 1. DNS Checks
        try {
            $dnsResult = Resolve-DnsName -Name $TargetHost -Type A -ErrorAction Stop
            if ($dnsResult.IPAddress -eq $PublicIP) {
                Write-Status "DNS (A Record)" $true "$TargetHost -> $PublicIP"
            } else {
                Write-Status "DNS (A Record)" $false "$TargetHost -> $($dnsResult.IPAddress) | Expected $PublicIP"
            }
        } catch {
            Write-Status "DNS (A Record)" $false "Could not resolve $TargetHost"
        }

        # 2. Connectivity Checks
        if (Test-Connection -ComputerName $PublicIP -Count 1 -Quiet) {
            Write-Status "Connectivity (Ping)" $true "ICMP Echo Reply from $PublicIP"
        } else {
            Write-Status "Connectivity (Ping)" $false "No ICMP Echo Reply from $PublicIP"
        }
        
        # --- CORRECTED PORT 80 CHECK ---
        $port80check = Test-NetConnection -ComputerName $PublicIP -Port 80 -WarningAction SilentlyContinue
        if ($port80check.TcpTestSucceeded) {
            $port80Message = "HTTP port is Open"
        } else {
            $port80Message = "HTTP port is Closed"
        }
        Write-Status "Connectivity (Port 80)" $port80check.TcpTestSucceeded $port80Message
        
        # --- CORRECTED PORT 443 CHECK ---
        $port443check = Test-NetConnection -ComputerName $PublicIP -Port 443 -WarningAction SilentlyContinue
        if ($port443check.TcpTestSucceeded) {
            $port443Message = "HTTPS port is Open"
        } else {
            $port443Message = "HTTPS port is Closed"
        }
        Write-Status "Connectivity (Port 443)" $port443check.TcpTestSucceeded $port443Message

        # 3. HTTP to HTTPS Redirect Check
        try {
            $httpReq = Invoke-WebRequest -Uri "http://$TargetHost" -MaximumRedirection 0 -UseBasicParsing -ErrorAction Stop -TimeoutSec 5
        } catch {
            if ($_.Exception.Response.StatusCode.value__ -eq 301 -or $_.Exception.Response.StatusCode.value__ -eq 308) {
                $location = $_.Exception.Response.Headers['Location']
                Write-Status "HTTP Redirect" $true "Correctly redirects to $location"
            } else {
                Write-Status "HTTP Redirect" $false "Unexpected response: $($_.Exception.Message)"
            }
        }

        # 4. SSL/TLS Certificate Check
        try {
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $tcpClient.Connect($TargetHost, 443)
            $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream(), $false)
            $sslStream.AuthenticateAsClient($TargetHost)
            $cert = $sslStream.RemoteCertificate
            
            if ($cert) {
                $daysUntilExpiry = ($cert.GetExpirationDateString() | Get-Date) - (Get-Date)
                Write-Status "SSL Certificate" $true "Certificate is present and loaded."
                Write-Status "  - Subject Name" ($cert.Subject -match $TargetHost) $cert.Subject
                Write-Status "  - Issuer" $true $cert.Issuer
                Write-Status "  - Expiration" ($daysUntilExpiry.Days -gt 0) "$($daysUntilExpiry.Days) days remaining"
            } else {
                 Write-Status "SSL Certificate" $false "Could not retrieve certificate."
            }
        } catch {
            Write-Status "SSL Certificate" $false "Connection failed: $($_.Exception.Message)"
        } finally {
            if($sslStream) { $sslStream.Dispose() }
            if($tcpClient) { $tcpClient.Dispose() }
        }

        # 5. Website Content Check
        try {
            $latency = Measure-Command {
                $httpsReq = Invoke-WebRequest -Uri "https://$TargetHost" -UseBasicParsing -ErrorAction Stop -TimeoutSec 10
            }
            if ($httpsReq.StatusCode -eq 200) {
                 Write-Status "Website Content" $true "Responded with HTTP 200 OK"
                 Write-Status "  - Latency" $true "$([math]::Round($latency.TotalMilliseconds)) ms"
            } else {
                 Write-Status "Website Content" $false "Responded with HTTP $($httpsReq.StatusCode)"
            }
        } catch {
            Write-Status "Website Content" $false "Request failed: $($_.Exception.Message)"
        }
    }

    Write-Host "`n--- Scan Complete. Waiting for $CheckIntervalSeconds seconds... ---"
    Start-Sleep -Seconds $CheckIntervalSeconds
}