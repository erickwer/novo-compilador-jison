%lex

%options flex case-insensitive

%%

\s+                                /* */
"/*"(.|\r|\n)*?"*/"                /* */
"//".*($|\r\n|\r|\n)               /* */
[\\n\\r]                  return 'NL';
\"[^\"]\"               return "STRING_LITERAL";
"mover para esquerda"   return "MOVER_ESQUERDA";
"mover para direita"    return "MOVER_DIREITA";
"se"                    return 'SE';
"entao"                 return 'ENTAO';
"senao"                 return 'SENAO';
"enquanto"              return 'ENQUANTO';
"memorizar"             return 'MEMORIZAR';
"ou"                    return 'OU_LOGICO';
"e"                     return 'E_LOGICO';
"V"                     return 'BOOLEAN_LITERAL';
"F"                     return 'BOOLEAN_LITERAL';
"nao"                   return 'NAO';
"nulo"                  return 'NULO';
[a-zA-Z]([a-zA-Z0-9])*  return "IDENTIFICADOR";
[0-9]+                  return "NUMERIC_LITERAL";
[0-9]+\.[0-9]+          return "NUMERIC_LITERAL";
"=="                    return 'IGUALDADE';
"="                     return 'ATRIBUICAO';
"+"                     return 'MAIS';
"-"                     return 'MENOS';
"*"                     return 'MULTIPLICACAO';
"/"                     return 'DIVISAO';
"%"                     return 'PORCENTO';
"^"                     return 'CIRCUNFLEXO';
"?"                     return 'INTERROGACAO';
">"                     return 'MAIOR_QUE';
"<"                     return 'MENOR_QUE';
"<="                    return 'MENOR_OU_IGUAL_QUE';
">="                    return 'MAIOR_OU_IGUAL_QUE'; 
"!="                    return 'DIFERENTE';
"!"                     return 'EXCLAMACAO';
"("						return 'EPAREN';
")"						return 'DPAREN';
"["                     return 'ECOLCHETE';
"]"                     return 'DCOLCHETE';
"."                     return 'PONTO';
","                     return 'VIRGULA';
"{"                     return 'ECHAVE';
"}"                     return 'DCHAVE';
";"                     return 'PONTO_E_VIRGULA';
":"                     return 'DOIS_PONTOS';
<<EOF>>                 return 'EOF';
.                       return 'INVALID';

/lex

%start programa

%ebnf

%right      ATRIBUICAO
%left       OU_LOGICO E_LOGICO
%nonassoc   IGUALDADE MAIOR_QUE MENOR_QUE MAIOR_OU_IGUAL_QUE MENOR_OU_IGUAL_QUE
%left       MAIS MENOS
%left       MULTIPLICACAO DIVISAO
%left       UMINUS
%left       INTERROGACAO

%%

programa 
    : blocos EOF 
        {
            $$ = new ProgramNode($1, location(@1, @2));
            return $$;  
        }
    ;

blocos
    : blocos bloco
        { $$ = merge($1, $2); }
    | bloco
    ;

bloco
    : sentencas PONTO
        {
            $$ = new BlocoStatementNode($1, location(@1, @2));
        }
    ;

sentencas
    : sentenca VIRGULA sentencas
        { $$ = merge($1, $3); }
    | sentenca
    ;

sentenca 
    : comando
    ;

comando
    : MOVER_ESQUERDA 
        { 
           $$ = new MoverParaEsquerdaStatementNode();
        }
    | MOVER_DIREITA
        {
            $$ = new MoverParaDireitaStatementNode();
        }
     
    ;



%%

function merge(a, b) {
    if (!Array.isArray(a)) {
        a = [a];
    }

    a.push(b);
    return a;
}

function SourceLocation(source, start, end) {
	this.source = source;
	this.start = start;
	this.end = end;
}

function Position(line, column) {
    return line + ',' + column;
}

function location(firstToken, lastToken) {
	return [ Position(firstToken.first_line, firstToken.first_column), Position(lastToken.last_line, lastToken.last_column) ];
}

function parseRegularExpressionLiteral(literal) {
	var last = literal.lastIndexOf("/");
	var body = literal.substring(1, last);
	var flags = literal.substring(last + 1);

	return new RegExp(body, flags);
}

function parseNumericLiteral(literal) {
	if (literal.charAt(0) === "0") {
		if (literal.charAt(1).toLowerCase() === "x") {
			return parseInt(literal, 16);
		} else {
			return parseInt(literal, 8);
		}
	} else {
		return Number(literal);
	}
}

var _originalParseMethod = parser.parse;
parser.parse = function(source, args) {
	parser.wasNewLine = false;
	parser.newLine = false;
	parser.restricted = false;

	return _originalParseMethod.call(this, source);
};
parser.parseError = function(str, hash) {
	if (!((hash.expected && hash.expected.indexOf("';'") >= 0) && (hash.token === "}" || hash.token === "EOF" || hash.token === "BR++" || hash.token === "BR--" || parser.newLine || parser.wasNewLine))) {
		throw new SyntaxError(str);
	}
};


var nodeId = 0;

function nextId() {
    return nodeId++;
}

function ProgramNode(blocos, location) {
    this.type = 'Programa';
    this.blocos = blocos;
    this.location = location;
    this.id = nextId();
}

function BlocoStatementNode(sentencas, location) {
    this.type = 'Bloco';
    this.sentencas = sentencas;
    this.location = location;
    this.id = nextId();
}

function ComandoStatementNode(name) {
    this.name = name;
}

function MoverParaEsquerdaStatementNode(posicao) {
    this.id = nextId();
    this.type = 'Comando';
    this.name = 'MoverParaEsquerda';
    this.posicao = 'posicao'

}

function MoverParaDireitaStatementNode(posicao) {
    this.id = nextId();
    this.type = 'Comando';
    this.name = 'MoverParaDireita';
    this.posicao = 'posicao'

}

function MarqueAquiStatementNode(location) {
    this.id = nextId();
    this.type = 'Comando';
    this.name = 'MarqueAqui';
    this.location = location;
}

function PontoNode(x, y, location) {
    this.id = nextId();
    this.type = 'Ponto';
    this.x = x;
    this.y = y;
    this.location = location;
}

