%{

%}
%left '+' '-'
%left '*' '/'
%left '^'
%left 'NEGACAO'

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



finalizadorLinha
    : ',' 
    | ';'
    | '.'
    ;



condicionais
    : SE logica ENTAO ':' sentencas %{ 
    
        if($2.val){
       // console.log($2);
            $$ = {
                nodeType: 'CONDICIONAL', 
                name: 'IF', 
                params: [$5] 
            };
        }else
        {
        //console.log($2);
               $$ = {
                nodeType: 'CONDICIONAL', 
                name: 'IF', 
                params: [] 
                     };  
        }
    %}

    | SE logica ENTAO ':' blocos SENAO ':' sentencas  
        %{
            if($2.val){
            $$ = {
                nodeType: 'CONDICIONAL', 
                name: 'IF', 
                params: [$5] 
            };
        }else
        {
               $$ = {
                nodeType: 'CONDICIONAL', 
                name: 'ELSE', 
                params: [$8] 
                     };  
        }
        %}   
    ;


repeticao
	: ENQUANTO numerica ATE numerica FACA ':' sentencas	
      %{
           

             $$ = {
                nodeType: 'ESTRUTURA DE REPETICAO', 
                name: 'ENQUANTO', 
                params: [$2,$4,$7] 
                     };   
        %} 
    ;

novoComando
:COMANDO STRING ':' blocos
  %{  
             $$ = {
                nodeType: 'NOVO COMANDO', 
                name: 'METODO', 
                params: [$2,$4] 
                     };   
        %} 
    ;

execultaComando
:CMD_EXE STRING
  %{  
             $$ = {
                nodeType: 'EXECULTA COMANDO', 
                name: 'METODO', 
                params: [$2] 
                     };   
        %} 
    ;

sentencas 
    : sentenca '.'
   | blocos '.'
   | expressao '.'
   | condicionais 
   | repeticao
   | novoComando '.'
   |execultaComando '.'
    | NL
    ;



bloco
    : '--' sentenca %{
            $$ = {
                nodeType: 'BLOCO', 
                comandos: $2
            };   
           
        %}
    ;
 
blocos
    : bloco  blocos?
      %{ 
        if($2==null)
        {
         $$ = { 
                nodeType: 'BLOCOS',
                value: [$1] 
            }; 

        }else{
                $$ = { 
                    nodeType: 'BLOCOS',
                    value: [$1, $2] 
                }; 
            }
        %}
    ;



expressao
    : numerica
	| logica
	| literal
    | CMD_ESCREVER '('literal')'                        
       %{
            $$ = {
                nodeType: 'CMD_ESCREVER',
                val: prompt($3, "")
            }; 
        %} 
    | logica CONJUNCAO  logica              
       %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $1.val || $3.val
            }; 
        %} 
    | logica DISJUNCAO  logica             
     %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $1.val && $3.val
            }; 
        %} 
    ;
	
literal : STRING ;
	
logica
	: '('logica')'                            
        %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $2.val
            }; 
        %}  


    | '(' logica CONJUNCAO  logica ')'         
       %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $2.val || $4.val
            }; 
        %}
   
    
    | '(' logica DISJUNCAO  logica ')'         
      %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $2.val && $4.val
            }; 
        %}
   
    | numerica '==' numerica                    
      %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $1.val == $3.val
            }; 
        %}
	
    | numerica '>' numerica                     
          %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $1.val > $3.val
            }; 
        %}

	| numerica '<' numerica      
    %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $1.val < $3.val
            }; 
        %}

	| numerica '>=' numerica 
      %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $1.val >= $3.val
            }; 
        %}

	| numerica '<=' numerica                    
	  %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $1.val <= $3.val
            }; 
        %}
    
    | literal '==' literal                      
	   %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: $1 == $3
            }; 
        %}

    | '~'  logica                              
       %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: !$2.val
            }; 
        %}
    
    | TRUE                                      
     %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: true
            }; 
        %}

    | FALSE                                    
       %{
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                val: false
            }; 
        %}
    | CMD_MARCA_AQUI                            
        %{
        vals = yy.parser.yy.marcaAqui(1);
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                nome:'CMD_MARCA_AQUI',
                val: vals
            }; 
        %}

    | CMD_NMARCA_AQUI                         
      %{
        vals = yy.parser.yy.marcaAqui(2);
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                nome:'CMD_NMARCA_AQUI',
                val: vals
            }; 
        %}
    | CMD_MARCA_EM ponto                     
      %{
        vals =yy.parser.yy.marcaEm(1,$2);
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                nome:'CMD_MARCA_EM',
                val: vals,
                params : $2
            }; 
        %}
    | CMD_NMARCA_EM ponto                   
      %{
        vals =yy.parser.yy.marcaEm(2,$2);
            $$ = {
                nodeType: 'EXPRESSAO_LOGICA',
                nome:'CMD_NMARCA_EM',
                val: vals,
                params : $2
            }; 
        %}
    ;



numerica
    : NUMERO   
        %{
            $$ = {
                nodeType: 'EXPRESSAO_NUMERO',
                val: Number(yytext)
            }; 
        %}
    
    
    | '-' numerica 
        %{
            $$ = {
                nodeType: 'EXPRESSAO_NUMERO',
                val: -($2.val)
            }; 
        %}
    
    
   
    | numerica '+' numerica  
     %{
            $$ = {
                nodeType: 'EXPRESSAO_NUMERO',
                name: 'SOMA',
                val: ($1.val + $3.val)
            }; 
        %}      
    | numerica '-' numerica   
         %{
            $$ = {
                nodeType: 'EXPRESSAO_NUMERO',
                name: 'SUBTRACAO',
                val: ($1.val - $3.val)
            }; 
        %}     
    | numerica '*' numerica  
         %{
            $$ = {
                nodeType: 'EXPRESSAO_NUMERO',
                name: 'MULTIPLICACAO',
                val: ($1.val * $3.val)
            }; 
        %}     
    | numerica '/' numerica   
         %{
            $$ = {
                nodeType: 'EXPRESSAO_NUMERO',
                name: 'DIVISAO',
                val: ($1.val / $3.val)
            }; 
        %}     
    
    | '(' numerica ')'
     %{
            $$ = {
                nodeType: 'EXPRESSAO_NUMERO',
                val: $2.val
            }; 
        %}
    ;

    
	
	
sentenca 
    : comando
    ;

direcao
    : NORTE
    | SUL
    | LESTE
    | OESTE
    ;



comando
    : CMD_MOVER_PARA ponto  %{ 
        $$ = {
            nodeType: 'COMANDO', 
            name: 'MOVER_PARA', 
            params: [$2] 
        };
    %}

    | CMD_MARQUE_AQUI  
    %{                    
     $$ = {
            nodeType: 'COMANDO', 
            name: 'CMD_MARQUE_AQUI' 
        };
    %}

	| CMD_DESMARQUE 
    %{      	                            
     $$ = {
            nodeType: 'COMANDO', 
            name: 'CMD_DESMARQUE' 
        };
    %} 
    | CMD_DESENHE_LINHA ponto                         
        %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_DESENHE_LINHA', 
                    params: [$2] 
                };
            %}
    
    | CMD_DESENHE_CIRC NUMERO                         
           %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_DESENHE_CIRC', 
                    params: [$2]
                };
            %}
    | CMD_POLIGONO pontos3    
         %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_POLIGONO', 
                    params: [$2] 
                };
            %}
    | CMD_ESCREVA STRING                             
       %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_ESCREVA', 
                    params: [$2] 
                };
        %} 
    | CMD_ESPESSURA_CA NUMERO                         
   %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_ESPESSURA_CA', 
                    params: [$2] 
                };
        %}

    | CMD_COR_CA STRING           
      %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_COR_CA', 
                    params: [$2] 
                };
        %}
                    
    | CMD_ESTILO_CA NUMERO               
     %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_ESTILO_CA', 
                    params: [$2] 
                };
        %}
    | CMD_QUADRI ponto ponto ponto 
            %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_QUADRI', 
                    params: [$2,$3,$4] 
                };
            %}            
    | CMD_DESENHE_TRI ponto ponto                 
          %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_DESENHE_TRI', 
                    params: [$2,$3] 
                };
            %}  

    |comandoMemorize 
    | CMD_MOV direcao                                
        %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_MOV', 
                    params: [$2] 
                };
            %}  
    | CMD_SAIDA '('literal')'  
     %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_SAIDA', 
                    params: [$3] 
                };
            %}                           

    ; 

comandoMemorize
: CMD_MEMORIZE expressao CMD_MEMORIZE_EM literal  
         %{ 
                $$ = {
                    nodeType: 'COMANDO', 
                    name: 'CMD_MEMORIZE - CMD_MEMORIZE_EM', 
                    params: [$2.val,$4] 
                };
            %} 
            ;




ponto
    : '(' numerica ',' numerica ')' 
        %{ 
            $$ = { 
                nodeType: 'PONTO',
                value: [$2, $4] 
            }; 
        %}
    ;
    
 
pontos3
    : ponto pontos3?
      %{ 
      if($2 == null)
      {
         $$ = { 
                nodeType: 'PONTO',
                value: [$1] 
            }; 
      }else
      {
      $$ = { 
                nodeType: 'PONTOS',
                value: [$1,$2] 
            }; 
      }

           
        %}
    ;
