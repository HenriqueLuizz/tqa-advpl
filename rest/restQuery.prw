#Include 'protheus.ch'
#Include 'restful.ch'

/*/{Protheus.doc} restQuery
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

WSRESTFUL MSTESTQUERY DESCRIPTION "Serviço de teste que query"

WSDATA query    AS CHARACTER 
WSDATA sgbds   AS CHARACTER 

WSMETHOD GET DESCRIPTION "Retorna a query passada pelo ChangeQuery e MSParse ou a falha da mesma" WSSYNTAX "/ms-test-query"

END WSRESTFUL

WSMETHOD GET WSSERVICE MSTESTQUERY
    
    Local cJson    AS Character
    Local oData    AS Object
    Local aParam   AS Array
    Local aResult  AS Array
    
    aParam = StrTokArr( ::sgbds, ',' )
    
    cJson := ::query
    
    oData := bqaTestQuery():New()
    oData:cQuery := cJson
    aResult := oData:testQuery(aParam)
    
    //varInfo("aResult", aResult)
    cJson := FWJsonSerialize(aResult,.T.,.T.)
    
    ::SetContentType("application/json")
    ::SetResponse(cJson)
Return .T.