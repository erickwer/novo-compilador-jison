%options flex case-insensitive
%%

[\\r\\n]+                        return 'NL';
\s+                             /* skip whitespace */
\#[^\r\n]*                      /* skip comments */
"mover para esquerda"                                return 'CMD_MOVER_PARA_ESQUERDA';
"mover para direita"                                return 'CMD_MOVER_PARA_DIREITA';
"mover para cima"                                return 'CMD_MOVER_PARA_CIMA';
"mover para baixo"                                return 'CMD_MOVER_PARA_BAIXO';
","						        			return ',';
"."						        			return '.';
";"                             			return ';';
<<EOF>>                                     return 'EOF';
.                                           return 'INVALID';
