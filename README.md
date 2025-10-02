# 🏋️ Wolf Gym Biometric Service

Servicio biométrico para Wolf Gym - Manejo de huellas dactilares con ZKTeco ZK9500.

## 🚀 Características

- ✅ Captura de huellas dactilares
- ✅ Registro de huellas (enrollment) con 3 muestras
- ✅ Verificación 1:1 (comparar huella con usuario específico)
- ✅ Identificación 1:N (buscar huella entre todos los usuarios)
- ✅ API REST completa
- ✅ Servicio de Windows
- ✅ Soporte para múltiples dominios

## 🛠️ Tecnologías

- **.NET 8.0** - Framework principal
- **ASP.NET Core** - API REST
- **ZKFinger SDK** - Integración con lector de huellas
- **PostgreSQL** - Base de datos
- **Entity Framework Core** - ORM

## 📋 Requisitos

### Hardware
- Lector de huellas ZKTeco ZK9500
- Windows 10/11 (64-bit)
- Mínimo 4GB RAM

### Software
- .NET 8.0 Runtime
- ZKFinger SDK (drivers)
- PostgreSQL (local o remoto)

## 🚀 Instalación

### 1. Instalar como Servicio de Windows

```powershell
# Ejecutar como Administrador
.\install-service.ps1
```

### 2. Configurar Acceso de Red

```powershell
# Ejecutar como Administrador
.\configure-network.ps1
```

### 3. Compilar desde Código Fuente

```bash
dotnet publish -c Release -r win-x64 --self-contained -o bin/Release/net8.0/win-x64/publish
```

## 🌐 Configuración de Red

### Cloudflare Tunnel (Recomendado)

```bash
# Instalar cloudflared
# https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/

# Crear tunnel
cloudflared tunnel create wolfgym-biometric

# Configurar tunnel
cloudflared tunnel route dns wolfgym-biometric biometric.wolf-gym.com

# Ejecutar tunnel
cloudflared tunnel --url http://localhost:8002 run wolfgym-biometric
```

### ngrok

```bash
# Instalar ngrok
# https://ngrok.com/download

# Ejecutar tunnel
ngrok http 8002
```

## 📡 API Endpoints

### Dispositivo
- `GET /device/status` - Estado del dispositivo
- `POST /device/open` - Abrir dispositivo
- `POST /device/close` - Cerrar dispositivo

### Captura
- `POST /capture` - Capturar huella

### Registro
- `POST /enroll` - Registrar huella (3 muestras)

### Verificación
- `POST /verify` - Verificar huella 1:1
- `POST /identify` - Identificar huella 1:N

## 🔧 Configuración

### Variables de Entorno

```env
# Base de datos
ConnectionStrings__DefaultConnection=Host=localhost;Port=5432;Database=wolfgym;Username=postgres;Password=password;

# CORS (opcional)
CorsOrigins__0=https://wolf-gym.com
CorsOrigins__1=https://www.wolf-gym.com
```

### Configuración de Producción

El archivo `appsettings.Production.json` contiene la configuración para producción con soporte para los dominios de Wolf Gym.

## 🧪 Pruebas

### Verificar Estado del Servicio

```powershell
Get-Service -Name WolfGymBiometricService
```

### Probar Endpoint

```powershell
Invoke-RestMethod -Uri "http://localhost:8002/device/status" -Method GET
```

## 📊 Logs

Los logs se guardan en:
- **Windows Event Log**: `Application` log, source `WolfGymBiometricService`
- **Archivo**: `C:\ProgramData\WolfGym\biometric\logs\`

## 🔄 Comandos de Administración

```powershell
# Iniciar servicio
Start-Service -Name WolfGymBiometricService

# Detener servicio
Stop-Service -Name WolfGymBiometricService

# Reiniciar servicio
Restart-Service -Name WolfGymBiometricService

# Ver estado
Get-Service -Name WolfGymBiometricService

# Desinstalar
sc.exe delete WolfGymBiometricService
```

## 🚨 Solución de Problemas

### Error: "Device busy"
- Verificar que no haya otra aplicación usando el lector
- Reiniciar el servicio

### Error: "Failed to open device"
- Verificar que el lector esté conectado
- Verificar que los drivers estén instalados
- Reiniciar la laptop

### Error de CORS
- Verificar que el dominio esté en la lista de CORS
- Verificar que el servicio esté escuchando en todas las interfaces

## 📞 Soporte

Para problemas o preguntas:
1. Revisar los logs del servicio
2. Verificar la configuración de red
3. Contactar al desarrollador

## 📄 Licencia

Propietario - Wolf Gym