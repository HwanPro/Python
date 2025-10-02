@echo off
echo 🔧 Ejecutando instalacion del servicio biométrico...
echo.
echo ⚠️  IMPORTANTE: Este script debe ejecutarse como Administrador
echo.
pause
powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-File', '.\install-service.ps1'"
