#include 'protheus.ch'
#include 'totvs.ch'

CLASS bqaTestQuery

DATA cQuery     AS CHARACTER
DATA cSGBD      AS CHARACTER
DATA bRetMSP    AS LOGICAL
DATA cRetMSP    AS CHARACTER
DATA cRetCQ     AS CHARACTER

METHOD New() CONSTRUCTOR
METHOD testQuery(oConn)

ENDCLASS

METHOD New() Class bqaTestQuery
Return Self

METHOD testQuery(aParam) Class bqaTestQuery
    
    LOCAL result    AS ARRAY
    LOCAL newTest   AS OBJECT
    LOCAL nX        AS NUMERIC

    result := {}

    DEFAULT aParam := {}

    //varInfo('aParam', aParam)

    For nX:= 1 to Len(aParam)
        
        newTest := bqaTestQuery():New()
        newTest:cSGBD := aParam[nX]
        
        //Abre a conexao com o SGBD que sera testado
        if (getConn(newTest:cSGBD))

            conout('Teste - ' + STR(nX))
            //varInfo('newTest', newTest)
        
            //Realiza o teste com o MSParse
            newTest:cRetMSP := MSParse(self:cQuery, newTest:cSGBD, .F.)
            //ConOut(newTest:cRetMSP + " --- MSParse utilizando "+TCGetDB())
            if(Len(newTest:cRetMSP) == 0 )
                newTest:bRetMSP := .F.
                newTest:cRetMSP := MSParseError()
                //ConOut(MSParseError() + " --- MSParseError utilizando "+TCGetDB())
            else
                newTest:bRetMSP:= .T.
                //Realiza o teste com a ChangeQuery
                newTest:cRetCQ := ChangeQuery(self:cQuery)
                //ConOut(newTest:cRetCQ + " --- ChangeQuery utilizando "+TCGetDB())
            endif

            AADD(result, newTest)
            //Fecha a conexao com o DBAccess do MSSQL
            closeConn()
        endif
    Next
    //varInfo('result', result)
Return result

STATIC FUNCTION openConn(cDBConn, cSrvConn, nPortConn)
   nPortConn := VAL(nPortConn)
   
  nHwnd := TCLink(cDBConn, cSrvConn, nPortConn)

  IIF(TCIsConnected(nHwnd),  CONOUT('TRUE'), CONOUT('FALSE'))

  if nHwnd >= 0
    conout("Conectado")
  endif
   
  //TCUnlink()
RETURN nHwnd

STATIC FUNCTION closeConn()
    TCUnlink()
RETURN

STATIC FUNCTION getConn(cSGBD)

    local cDatabase
    local cAlias
    local cServer
    local nPort

    cSGBD := AllTrim(cSGBD)

    DO CASE
        CASE cSGBD == 'ORACLE'
            cDatabase   := AllTrim(GetPvProfString("ORACLEAnalyzer", "Database", "ORACLE", GetAdv97()))
            cAlias      := AllTrim(GetPvProfString("ORACLEAnalyzer", "Alias", "qryanalyser", GetAdv97()))
            cServer     := AllTrim(GetPvProfString("ORACLEAnalyzer", "Server", "10.171.67.143", GetAdv97()))
            nPort       := AllTrim(GetPvProfString("ORACLEAnalyzer", "Port", "7777", GetAdv97()))
        CASE cSGBD == 'MSSQL'
            cDatabase   := AllTrim(GetPvProfString("MSSQLAnalyzer", "Database", "MSSQL", GetAdv97()))
            cAlias      := AllTrim(GetPvProfString("MSSQLAnalyzer", "Alias", "qryanalyser", GetAdv97()))
            cServer     := AllTrim(GetPvProfString("MSSQLAnalyzer", "Server", "10.171.67.123", GetAdv97()))
            nPort       := AllTrim(GetPvProfString("MSSQLAnalyzer", "Port", "7777", GetAdv97()))
        CASE cSGBD == 'POSTGRESQL'
            cDatabase   := AllTrim(GetPvProfString("POSTGRESAnalyzer", "Database", "POSTGRES", GetAdv97()))
            cAlias      := AllTrim(GetPvProfString("POSTGRESAnalyzer", "Alias", "qryanalyser", GetAdv97()))
            cServer     := AllTrim(GetPvProfString("POSTGRESAnalyzer", "Server", "10.171.67.118", GetAdv97()))
            nPort       := AllTrim(GetPvProfString("POSTGRESAnalyzer", "Port", "7777", GetAdv97()))
        OTHERWISE
            RETURN .F.
    ENDCASE

    //Realiza a abertura da conexao com o DBAccess do MSSQL
    if(openConn(cDatabase + '/' + cAlias,cServer,nPort) < 0)
        Return .F.
    endif
RETURN .T.