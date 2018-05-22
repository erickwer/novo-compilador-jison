/*
* Define a classe Interpretador, com funções para processamento de uma
* AST no contexto da gramática definida em easy.js
*/
function Interpretador(saida, canvasId) {
    this.saida = saida;
    this.canvasId = canvasId;
    this.canvas = new fabric.StaticCanvas(this.canvasId); //pra criar formas simples. ex.: triangulo 
    this.pontoAtual = null;
    this.ator = null;
    this.posicao = 0;
    this.iniciar();
    
}

/*
* Este método inicia a posição do ator (no centro do canvas).
*/
Interpretador.prototype.iniciar = function() {
    /* encontra o meio do canvas (altura e largura) */
    var x = this.canvas.width/2, y = this.canvas.height/2;

    /* cria o ator, um retângulo posicionado em x e y */
    this.ator = new fabric.Rect({
        left: x, top: y, fill: 'black', 
        width: 20, height: 20, angle: 80
    });

    function desenharPersonagem(){
        context.clearRect(0,0,canvas.width,canvas.height);
        context.fillRect(posicao, 100, 20, 50)
    }

    /* adiciona o ator ao canvas */
    this.canvas.add(this.ator); 
    this.pontoAtual = {x: x, y: y};
}

/*
* Este método percorre a árvore recursivamente e, conforme cada tipo de nó,
* executa a operação apropriada.
*/
Interpretador.prototype.executarComando = function(estado) {
    /*  se o parâmetro no não estiver definido
        então inicia a execução pela raiz da AST
    */
    if (!estado) 
        estado = this.saida;

    if (estado.type == 'Programa') {
        /* se o nó for do tipo programa */        
        /* percorre os blocos */
        /* se há um array de blocos */
        if (Array.isArray(estado.blocos)) {
            /* chama a função recursivamente para cada bloco */
            for(var i = 0; i < estado.blocos.length; i++) {
                this.executarComando(estado.blocos[i]);
            }
        } else {
            /* se há apenas um bloco */
            /* chama a função recursivamente para o bloco */
            this.executarComando(estado.blocos);
        }
    } else if (estado.type == 'Bloco') {
        /* se o nó for do tipo bloco */
        /* se há um array de sentenças */
        if (Array.isArray(estado.sentencas)) {
            /* chama a função recursivamente para cada sentença */
            for(var i = 0; i < estado.sentencas.length; i++) {
                this.executarComando(estado.sentencas[i]);
            }        
        } else {
            /* se há apenas uma sentença */
            /* chama a função recursivamente para a sentença */
            this.executarComando(estado.sentencas);
        }
    } else if (estado.type == 'Comando') {
        /* se o nó for do tipo comando */
        if (estado.name == 'MoverParaEsquerda') {
            /* se o comando for 'mover para' */
            this.moverPara(estado.ponto[0], estado.ponto[1]);
            this.pontoAtual = 0;
            this.pontoAtual -= 10;
            return this.pontoAtual;
            //posicao -= 10;
            //desenharPersonagem();
        } else if (estado.name == 'MoverParaDireita') {
            /* se o comando for 'marque aqui' */
            this.marqueAqui(this.pontoAtual.x, this.pontoAtual.y);
            this.pontoAtual = 0;
            this.pontoAtual += 10
            return this.pontoAtual;
            //posicao -= 10;
            //desenharPersonagem();
        }
    }
}

/*
* Este método move o ator para a posição definida por x e y
*/
Interpretador.prototype.moverPara = function(x, y) {
    /* guarda o ponto atual em formato de objeto */ 
    this.pontoAtual = {x: x, y: y};
    /* move o ator usando recurso de animação da fabric.js */ 
    this.ator.animate({'left': x, 'top': y}, {
        /* atualiza o canvas */
        onChange: this.canvas.renderAll.bind(this.canvas)
    });    
}

/*
* Este método cria uma marca (um círculo) na posição definida por x e y
*/
Interpretador.prototype.marqueAqui = function(x, y) {
    /* cria um círculo na posição definida por x e y */
    var circle = new fabric.Circle({
        radius: 5, fill: 'red', left: x, top: y
    });
    /* adiciona o círculo no canvas */
    this.canvas.add(circle);
}

/*
* Este método limpa o canvas e reinicia a posição do ator
*/
Interpretador.prototype.clear = function() {
    this.canvas.clear();
    this.iniciar();
    this.pontoAtual = null;
    
}

if (typeof require !== 'undefined' && typeof exports !== 'undefined') {
    exports.Interpretador = Interpretador;
}
