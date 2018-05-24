

%options flex case-insensitive

%start programa
%ebnf
%%

programa 
    : sentencas + EOF 
        {
            $$ = {
                nodeType: 'PROGRAMA', 
                sentencas: $1
            };
            return $$;  
        }
    ;



finalizadorLinha
    : ',' 
    | ';'
    | '.'
    ;


sentencas
    : comando '.'
    ;

comando 
    : CMD_MOVER_PARA_ESQUERDA
        {
            $$ = {
                nodeType:'COMANDO',
                name: 'CMD_MOVER_PARA_ESQUERDA';
                };
        }
    | CMD_MOVER_PARA_DIREITA 
        {
            $$ = {
                nodeType:'COMANDO',
                name: 'CMD_MOVER_PARA_DIREITA';
            };
        }

    | CMD_MOVER_PARA_CIMA 
        {
            $$ = {
                nodeType:'COMANDO',
                name: 'CMD_MOVER_PARA_CIMA';
            };
        }

    |  CMD_MOVER_PARA_BAIXO 
        {
            $$ = {
                nodeType:'COMANDO',
                name: 'CMD_MOVER_PARA_BAIXO';
            };
        }
    
    ;


