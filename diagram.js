function Diagram(c) {
    this.ponto = [];
	//this.texto = texto;
	this.c = c;
	this.x= 10;
	this.y = 10;
    this.Rx = 10;
    this.Ry = 10;
    this.PPontos = [];
    this.Dpoligono = [];
    this.Dquadri = [];
    this.Dtriangulo = [];
    this.xx=Array();
    this.yy=Array();
    this.DCirc = [];
    this.ETexto = [];
    this.img; 
    this.Dlinhas = [];
    this.EspCaneta = 3;
     this.CorCaneta = "Black";
     this.TipoLinha = 0;
     this.Variaveis = Array();
        this.metodos = Array();
     this.Direcao = "leste";
}



function ParseError(message, hash) {
    _.extend(this, hash);

    this.name = "ParseError";
    this.message = (message || "");
    
}

ParseError.prototype = new Error();
Diagram.ParseError = ParseError;
Diagram.parse = function (input,c) {
    // Create the object to track state and deal with errors
    gramatica.yy = new Diagram(c);     
    gramatica.yy.parseError = function (message, hash) {  
    var  ctx = c.getContext("2d");
    ctx.clearRect(0, 0,c.width ,c.height );      
    document.getElementById("saidaText").innerHTML = message;
    console.log(message);
    throw new ParseError(message, hash);
    };
    // Parse
    var diagram = gramatica.parse(input);
    // Then clean up the parseError key that a user won't care about
    delete diagram.parseError; 
    gramatica.yy.interpretador(diagram);  
    return diagram;
};



Diagram.prototype.interpretador = function(dados) {
    for(var x = 0 ;x < dados.sentencas.length; x++)
    {       
        console.log(dados.sentencas)
        if(dados.sentencas[x].name=="MOVER_PARA")
            { 
            gramatica.yy.moverPara(dados.sentencas[x].params[0].value);  
            //console.log(dados.sentencas[x].params[0].value);            
            }
    }
    
}


Diagram.prototype.moverPara = function(ponto) {
    this.img = 1;
    gramatica.yy.Ponto(ponto[0].val,ponto[1].val);
    this.desenharFormas();
}

Diagram.prototype.desenharFormas = function() {
    var ctx = this.c.getContext("2d");
    ctx.clearRect(0, 0,this.c.width ,this.c.height);
    console.log(this.TipoLinha)
    if(this.TipoLinha == 1)
    {
         var dashList = [5, 5, 5, 5];
         ctx.setLineDash(dashList);
    }else{

         var dashList = [0, 0, 0, 0];
         ctx.setLineDash(dashList);
    } 
    $("#saidaText").html("");

    DesenhaPonto(ctx,this.x,this.y,this.img);
    
}

Diagram.prototype.Ponto = function (x, y) {
    this.Rx = this.x;
    this.Ry = this.y;
    this.x = x;
    this.y = y;
    return [x, y];
}

Diagram.prototype.saida = function (valor) {
    console.log("Função de saida")
    valor = valor.replace('"', "");
    $("#saidaText").html(valor);
}

function DesenhaPonto(ctx, x, y, imagem) {
    console.log(imagem)
    if (imagem == 1) {
        var img = document.getElementById("ponto");
    }

    ctx.drawImage(img, x, y, 32, 32);

    

}
























