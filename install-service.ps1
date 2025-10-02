# Script para instalar el servicio biométrico como servicio de Windows
# Ejecutar como Administrador

param(
    [string]$ServiceName = "WolfGymBiometricService",
    [string]$DisplayName = "Wolf Gym Biometric Service",
    [string]$Description = "Servicio biométrico para Wolf Gym - Manejo de huellas dactilares",
    [string]$Port = "8002"
)

Write-Host "🔧 Instalando servicio biométrico..." -ForegroundColor Green

# Detener servicio si existe
if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "⏹️ Deteniendo servicio existente..." -ForegroundColor Yellow
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
    sc.exe delete $ServiceName
    Start-Sleep -Seconds 2
}

# Obtener la ruta del ejecutable
$ExePath = Join-Path $PSScriptRoot "bin\Release\net8.0\win-x64\publish\WolfGym.BiometricService.exe"

if (-not (Test-Path $ExePath)) {
    Write-Host "❌ No se encontró el ejecutable en: $ExePath" -ForegroundColor Red
    Write-Host "💡 Primero ejecuta: dotnet publish -c Release -r win-x64 --self-contained -o bin\Release\net8.0\win-x64\publish" -ForegroundColor Yellow
    exit 1
}

# Crear el servicio
Write-Host "📦 Creando servicio..." -ForegroundColor Blue
sc.exe create $ServiceName binPath= "`"$ExePath`"" DisplayName= "`"$DisplayName`"" start= auto

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error creando el servicio" -ForegroundColor Red
    exit 1
}

# Configurar descripción
sc.exe description $ServiceName "`"$Description`""

# Configurar para reiniciar automáticamente en caso de fallo
sc.exe failure $ServiceName reset= 86400 actions= restart/5000/restart/10000/restart/20000

# Iniciar el servicio
Write-Host "🚀 Iniciando servicio..." -ForegroundColor Green
Start-Service -Name $ServiceName

if (Get-Service -Name $ServiceName | Where-Object {$_.Status -eq "Running"}) {
    Write-Host "✅ Servicio instalado y ejecutándose correctamente" -ForegroundColor Green
    Write-Host "🌐 Servicio disponible en: http://localhost:$Port" -ForegroundColor Cyan
    Write-Host "📊 Para ver logs: Get-EventLog -LogName Application -Source '$ServiceName' -Newest 10" -ForegroundColor Yellow
} else {
    Write-Host "❌ Error iniciando el servicio" -ForegroundColor Red
    Write-Host "🔍 Revisa los logs del sistema para más detalles" -ForegroundColor Yellow
}

Write-Host "`n📋 Comandos útiles:" -ForegroundColor Magenta
Write-Host "  Detener:   Stop-Service -Name $ServiceName" -ForegroundColor White
Write-Host "  Iniciar:   Start-Service -Name $ServiceName" -ForegroundColor White
Write-Host "  Estado:    Get-Service -Name $ServiceName" -ForegroundColor White
Write-Host "  Desinstalar: sc.exe delete $ServiceName" -ForegroundColor White
