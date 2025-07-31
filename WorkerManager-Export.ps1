# Busca todos os serviços do Windows com nome "Benner Tasks Worker*"
$servicos = Get-WmiObject Win32_Service | Where-Object { $_.DisplayName -like "Benner Tasks Worker*" }

# Início da declaração
$saida = "`$workers = @(`n"

foreach ($svc in $servicos) {
    $exePath = $svc.PathName -replace '"', ''  # Remove aspas
    $installDir = Split-Path $exePath -Parent
    $configPath = Join-Path $installDir "Benner.Tecnologia.Tasks.Worker.exe.config"
    $pasta = Split-Path $installDir -Leaf

    if (Test-Path $configPath) {
        [xml]$xml = Get-Content $configPath

        # Extrai os valores do XML
        $settings = @{}
        foreach ($add in $xml.configuration.appSettings.add) {
            $settings[$add.key] = $add.value
        }

        # Ajusta NomeServico: se estiver vazio ou ausente, usa o nome da pasta
        $nomeServico = if ($settings.ContainsKey("NomeServico") -and $settings["NomeServico"].Trim() -ne "") {
            $settings["NomeServico"]
        } else {
            $pasta
        }

        # Constrói a entrada no formato desejado
        $saida += "    @{ Pasta = `"$pasta`";"
        $saida += " Sistema = `"$($settings["Sistema"])`";"
        $saida += " Servidor = `"$($settings["Servidor"])`";"
        $saida += " NumeroDeProviders = $($settings["NumeroDeProviders"] -as [int]);"
        $saida += " Usuario = `"$($settings["Usuario"])`";"
        $saida += " Fila = `"$($settings["Fila"])`";"
        $saida += " UseCOMFree = `"$($settings["UseCOMFree"])`";"
        $saida += " LoggingServerActive = `"$($settings["LoggingServerActive"])`";"
        $saida += " LoggingServerAddress = `"$($settings["LoggingServerAddress"])`";"
        $saida += " NomeServico = `"$nomeServico`";"
        $saida += " PoolDinamica = `"$($settings["PoolDinamica"])`";"

        # Parâmetros opcionais
        if ($settings.ContainsKey("PrimaryMessageFilterSQL")) {
            $saida += " PrimaryMessageFilterSQL = `"$($settings["PrimaryMessageFilterSQL"])`";"
        }
        if ($settings.ContainsKey("SecondaryMessageFilterSQL")) {
            $saida += " SecondaryMessageFilterSQL = `"$($settings["SecondaryMessageFilterSQL"])`";"
        }

        if ($settings.ContainsKey("MultiplicadorCPU")) {
            $saida += " MultiplicadorCPU = $($settings["MultiplicadorCPU"] -as [int]);"
        }

        $saida += " ServiceName = `"BennerTasksWorker_$([guid]::NewGuid())`" },`n"
    } else {
        Write-Warning "⚠️ Arquivo de configuração não encontrado para o serviço '$($svc.DisplayName)' em '$installDir'"
    }
}

# Remove vírgula final e fecha o array
$saida = $saida.TrimEnd("`,", "`n") + "`n)"

# Exporta no console e/ou salva em arquivo
$basePath = "C:\TEMP"
$saida | Out-File -FilePath "$basePath\export_workers.ps1" -Encoding UTF8
Write-Output $saida
