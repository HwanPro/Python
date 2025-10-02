# Script para configurar el servicio biométrico para acceso de red
# Ejecutar como Administrador

param(
    [string]$Port = "8002",
    [string]$ServiceName = "WolfGymBiometricService"
)

Write-Host "🌐 Configurando acceso de red para el servicio biométrico..." -ForegroundColor Green

# Verificar que el servicio esté ejecutándose
if (-not (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq "Running"})) {
    Write-Host "❌ El servicio $ServiceName no está ejecutándose" -ForegroundColor Red
    Write-Host "💡 Primero ejecuta: .\install-service.ps1" -ForegroundColor Yellow
    exit 1
}

# Configurar regla de firewall para el puerto
Write-Host "🔥 Configurando regla de firewall..." -ForegroundColor Blue
$FirewallRuleName = "WolfGym-Biometric-Service-$Port"

# Eliminar regla existente si existe
Remove-NetFirewallRule -DisplayName $FirewallRuleName -ErrorAction SilentlyContinue

# Crear nueva regla
New-NetFirewallRule -DisplayName $FirewallRuleName -Direction Inbound -Protocol TCP -LocalPort $Port -Action Allow -Profile Any

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Regla de firewall creada correctamente" -ForegroundColor Green
} else {
    Write-Host "⚠️ Error creando regla de firewall (puede que ya exista)" -ForegroundColor Yellow
}

# Obtener IP local
$LocalIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"} | Select-Object -First 1).IPAddress

Write-Host "`n🌐 Configuración completada:" -ForegroundColor Magenta
Write-Host "  Puerto local: $Port" -ForegroundColor White
Write-Host "  IP local: $LocalIP" -ForegroundColor White
Write-Host "  URL local: http://localhost:$Port" -ForegroundColor White
Write-Host "  URL red: http://$LocalIP`:$Port" -ForegroundColor White

Write-Host "`n📋 Para usar con Cloudflare Tunnel:" -ForegroundColor Cyan
Write-Host "  cloudflared tunnel --url http://localhost:$Port" -ForegroundColor White

Write-Host "`n📋 Para usar con ngrok:" -ForegroundColor Cyan
Write-Host "  ngrok http $Port" -ForegroundColor White

Write-Host "`n⚠️ IMPORTANTE:" -ForegroundColor Yellow
Write-Host "  - Asegúrate de que el puerto $Port esté abierto en tu router" -ForegroundColor White
Write-Host "  - Usa HTTPS en producción (Cloudflare, ngrok, etc.)" -ForegroundColor White
Write-Host "  - Configura autenticación si es necesario" -ForegroundColor White
