# Diagnostico-OneDrive.ps1
# Autor: Pablo Luis Portela Elias
# Função: Diagnóstico técnico para suporte N3 – OneDrive corporativo

Write-Host "==== Diagnóstico de Sincronização OneDrive ====" -ForegroundColor Cyan

# Verifica se o OneDrive está em execução
$onedrive = Get-Process OneDrive -ErrorAction SilentlyContinue
if ($onedrive) {
    Write-Host "[✔] OneDrive está em execução." -ForegroundColor Green
} else {
    Write-Host "[✖] OneDrive não está em execução." -ForegroundColor Red
}

# Caminho de instalação do OneDrive
$onedrivePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
if (Test-Path $onedrivePath) {
    Write-Host "[✔] Caminho de instalação encontrado: $onedrivePath"
} else {
    Write-Host "[✖] OneDrive não está instalado corretamente."
}

# Verifica status do cliente de sincronização
Write-Host "`n--- Verificando conexões de rede com a Microsoft ---"
Test-NetConnection -ComputerName "onedrive.live.com" -Port 443

# Lista de logs recentes (eventos)
Write-Host "`n--- Últimos 10 eventos do OneDrive ---"
Get-WinEvent -LogName "Microsoft-Windows-Shell-Core/Operational" -MaxEvents 10 |
Where-Object { $_.Message -like "*OneDrive*" } |
Select-Object TimeCreated, Message

# Reinicialização do processo (opcional)
$reiniciar = Read-Host "Deseja reiniciar o OneDrive? (s/n)"
if ($reiniciar -eq "s") {
    Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
    Start-Process $onedrivePath
    Write-Host "OneDrive reiniciado com sucesso." -ForegroundColor Green
}

Write-Host "`nDiagnóstico concluído." -ForegroundColor Cyan
