# tqa-advpl
Query Analyzer ADVPL

## Build ADVPL
Complie os fontes `bqaTestQuery.prw` e `restQuery.prw` no RPO do ambinete Protheus onde irá subir o REST.

## Configure o APPSERVER.INI
Seção `[ORACLEAnalyzer]`  
Chave `Database` padrão `"ORACLE"`
Chave `Alias` padrão `"qryanalyser"`
Chave `Server` padrão `10.171.67.143`
Chave `Port` padrão `7777`

Seção `[MSSQLAnalyzer]` 
Chave `Database` padrão `"MSSQL"`
Chave `Alias` padrão `"qryanalyser"`
Chave `Server` padrão `10.171.67.123`
Chave `Port` padrão `7777`

Seção `[POSTGRESAnalyzer]` 
Chave `Database` padrão `POSTGRES`
Chave `Alias` padrão `"qryanalyser"`
Chave `Server` padrão `10.171.67.118`
Chave `Port` padrão `7777`

```ini
[ORACLEAnalyzer]
Alias=qryanalyser
Server=10.171.67.143
Port=7777

[MSSQLAnalyzer]
Alias=qryanalyser
Server=10.171.67.123
Port=7777

[POSTGRESAnalyzer]
Alias=qryanalyser
Server=10.171.67.118
Port=7777
```

## Configuração do REST

```ini
[ONSTART]
JOBS=HTTPJOB
REFRESHRATE=120

[HTTPJOB]
MAIN=HTTP_START
ENVIRONMENT=environment

[HTTPV11]
Enable=1
Sockets=HTTPREST

[HTTPREST] 
Port=8080
IPsBind=
URIs=HTTPURI
Security=0

[HTTPURI]
URL=/rest
PrepareIn=
Instances=1,1
CORSEnable=1
AllowOrigin=*
```