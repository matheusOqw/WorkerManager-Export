# WorkerManager-Export
Script para exportação do config do worker

# Exportador de Serviços Benner Tasks Worker

Este script PowerShell busca e coleta informações de todos os serviços do Windows com nome `Benner Tasks Worker*`, extrai parâmetros do arquivo de configuração `.config` e gera uma estrutura de dados com essas informações.

## 📌 O que o script faz

- Localiza serviços ativos chamados `Benner Tasks Worker*`
- Lê o arquivo `Benner.Tecnologia.Tasks.Worker.exe.config` de cada serviço
- Extrai parâmetros como:
  - Sistema
  - Servidor
  - Usuario
  - NumeroDeProviders
  - Fila
  - Nome do Serviço
  - Configurações de log e filtros (se existirem)
- Gera um objeto PowerShell `$workers` contendo todos os dados formatados
- Exporta o resultado para o arquivo `C:\TEMP\export_workers.ps1`

## 🚀 Como usar

1. **Abra o PowerShell como Administrador**
2. Execute o script com permissões adequadas
3. Verifique a saída na tela e o arquivo `C:\TEMP\export_workers.ps1`

## 🖥️ Exemplo de saída

```powershell
$workers = @(
    @{ Pasta = "RH-CRP-AGENDAMENTO"; Sistema = "RH"; Servidor = "OCI060-CLI147"; NumeroDeProviders = 5; Usuario = "SYSDBA"; Fila = "Z_AGENDAMENTOREQUISICOES"; UseCOMFree = "True"; LoggingServerActive = "False"; LoggingServerAddress = ""; NomeServico = "CRP-AGENDAMENTO"; PoolDinamica = "false"; MultiplicadorCPU = 1; ServiceName = "BennerTasksWorker_..." },
    ...
)
