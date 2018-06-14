%lex

%options flex case-insensitive

%%

\s+                                /* */
"/*"(.|\r|\n)*?"*/"                /* */
"//".*($|\r\n|\r|\n)               /* */
[\\n\\r]                return 'NL';
\"[^\"]\"               return "STRING_LITERAL";
"mover para"            return "MOVER_PARA";
"desenhe uma linha ate"   return "DESENHE_LINHA"
"se"                    return 'SE';
"entao"                 return 'ENTAO';
"senao"                 return 'SENAO';
"enquanto"              return 'ENQUANTO';
"memorize"             return 'MEMORIZAR';
\"[^\"]*\"|\'[^\']*\'                       return 'STRING';
"*"                                         return '*';
"/"                                         return '/';
"-"                                         return '-';
"--"                                        return '--';
"+"                                         return '+';
"("                                         return '(';
")"                                         return ')';
"{"                                         return '{';
"}"                                         return '}';
","                                         return ',';
"."                                         return '.';
";"                                         return ';';

">"                                         return '>';
"<"                                         return '<';
">="                                        return '>=';
"<="                                        return '<=';
"=="                                        return '==';
"="                                         return '=';
"~"                                         return '~';
"or"                                        return 'CONJUNCAO';
"and"                                       return 'DISJUNCAO';



"true"                                      return 'TRUE';  
"false"                                     return 'FALSE';

"se"                                        return 'SE';
"entao"                                     return 'ENTAO';
"senao"                                     return 'SENAO';
":"                                         return ':';
 
"para contador de"                          return 'ENQUANTO';
"novo comando"                              return 'COMANDO';
"execultar comando"                         return 'CMD_EXE';
"ate"                                       return 'ATE';
"faca"                                      return 'FACA';



\d*\.\d+                                    return 'NUMERO';
[1-9][\d]*|[0]+                             return 'NUMERO';
<<EOF>>                                     return 'EOF';
.                                           return 'INVALID';

/lex
%start programa

%ebnf

%%

programa 
    : sentencas+ EOF 
        %{
            $$ = {
                nodeType: 'PROGRAMA', 
                sentencas: $1
            };
            return $$;  
        %}
    ;

sentencas
    : comando '.'
    ;

comando
    : MOVER_PARA ponto  %{
        $$ = {
            nodeType: 'COMANDO',
            name: 'MOVER_PARA',
            params: [$2]
        };
    %}
    ;
ponto
    : '(' numeros ',' numeros ')' %{
        $$ = {
            nodeType: 'PONTO',
            value: [$2,$4]
        };
    %}
    ;

numeros 
    : NUMERO %{
    $$ = {
                nodeType: 'NUMEROS',
                val: Number(yytext)
            }; 
    %}
    ;