#Author: Ivo Dias
#URL: https://github.com/IGDEXE/PS-Google-Catch/blob/master/GoogleSearch.psm1
function Get-GoogleAnswer {
    param (
        [Parameter(Mandatory, ValueFromRemainingArguments)]    
        $mensagemErro
    )
    # Abre uma pesquisa com o termo que deu erro
    Start-Process "https://www.google.com/search?q=$mensagemErro"
}
