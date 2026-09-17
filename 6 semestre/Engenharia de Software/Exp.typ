#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages, stroke: 1pt + luma(100))

#import "@preview/tablex:0.0.9": tablex, rowspanx, colspanx, cellx

#set page(width: 21cm, height: 30cm, margin: 1.5cm)

#set par(
  justify: true
)

#set figure(supplement: "Figura")

#set heading(numbering: "1.1.1")

#let theorem = thmbox("theorem", "Teorema")
#let corollary = thmplain(
  "corollary",
  "Corolário",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definição", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Exemplo").with(numbering: none)
#let proof = thmproof("proof", "Demonstração")

#set math.equation(
  numbering: "(1)",
  supplement: none,
)
#show ref: it => {
  // provide custom reference for equations
  if it.element != none and it.element.func() == math.equation {
    // optional: wrap inside link, so whole label is linked
    link(it.target)[(#it)]
  } else {
    it
  }
}

#set text(
  font: "Atkinson Hyperlegible",
  size: 12pt,
)

#show heading: it => {
  if it.level == 1 {
    [
      #block(
        width: 100%,
        height: 1cm,
        text(
          size: 1.5em,
          weight: "bold",
          it.body
        )
      )
    ]
  } else {
    it
  }
}


// ============================ PRIMEIRA PÁGINA =============================
#align(center + top)[
  FGV EMAp

  Thalis Ambrosim Falqueto
]

#align(horizon + center)[
  #text(17pt)[
    Engenharia de Software
  ]

  #text(14pt)[
    Holy emapian
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2026
]

#pagebreak()

// ============================ PÁGINAS POSTERIORES =========================
#outline(title: "Conteúdo")

#pagebreak()

= Aula 1 - Documentação, Contratos e SRP

A aula usa dois exemplos: a "Cacto" é simplesmente uma loja de cactos com um método de quase $90$ linhas que faz de tudo (aparentemente feito por algum aluno de LP), sem nenhuma documentação, e a "Loja" é o exercício de correção, que isola só a fatia de "calcular o frete" desse mesmo problema pra refatorar passo a passo, do jeito errado até o SRP resolvido.

== Cacto

A loja vende cactos — cada um com nome, preço e altura — e monta pedidos com vários itens:

```python
class Cacto:
    def __init__(self, nome, preco, altura_cm):
        self.nome = nome
        self.preco = preco
        self.altura_cm = altura_cm


class ItemPedido:
    def __init__(self, cacto, quantidade):
        self.cacto = cacto
        self.quantidade = quantidade
```

Exemplo de *design by contract* citado em aula: o `__init__` de `ItemPedido` já declara, o que consome pra funcionar — um `cacto` e uma `quantidade`. Só que, como o próprio comentário no código admite, nada garante que `cacto` é de fato um `Cacto`. Documentar com docstring é pedir pra quem for usar a classe seguir o combinado: Python é fracamente tipado, então nada impede alguém de passar qualquer coisa ali. A saída ingênua seria verificar o tipo dentro do `__init__`, mas fazer esse tipo de verificação em todos os métodos e todos os parâmetros deixa o programa lento. Aí que entra o termo dito pelo Pinho: você declara o comportamento esperado e confia que quem chamou respeitou, em vez de reverificar tudo o tempo todo. 

Na média, tudo que é interno ao sistema é tratado assim, e a verificação de fato só entra quando o sistema recebe algo de fora dele. Se um contrato não é respeitado, a consequência pode ser tão grave quanto o caso citado em aula do foguete da NASA que explodiu (não explodiu, mas *ver*).

Continuando o código, o pedido guarda os dados do cliente e a lista de itens:

```python
class Pedido:
    def __init__(self, cliente, email, cep, tipo_entrega, cupom, numero_cartao):
        self.cliente = cliente
        self.email = email
        self.cep = cep
        self.tipo_entrega = tipo_entrega
        self.cupom = cupom
        self.numero_cartao = numero_cartao
        self.itens = []
```

E a entrega tem quatro formas possíveis, todas implementando o mesmo contrato abstrato:

```python
class Entrega(ABC):
    @abstractmethod
    def calcular_frete(self, peso_kg, cep):
        ...

    @abstractmethod
    def prazo_em_dias(self, cep):
        ...

    @abstractmethod
    def codigo_rastreio(self):
        ...


class Sedex(Entrega):
    def calcular_frete(self, peso_kg, cep):
        base = 18.90 + peso_kg * 2.35
        if cep.startswith("6") or cep.startswith("7"):
            base = base * 1.4
        return base

    def prazo_em_dias(self, cep):
        return 2 if cep.startswith("0") else 5

    def codigo_rastreio(self):
        return "BR314159265BR"


class Drone(Entrega):
    def calcular_frete(self, peso_kg, cep):
        base = 49.90 + peso_kg * 8.0
        if peso_kg > 3.0:
            base = base + 60.0
        return base

    def prazo_em_dias(self, cep):
        return 1

    def codigo_rastreio(self):
        return "DRN-8080"


class PomboCorreio(Entrega):
    def calcular_frete(self, peso_kg, cep):
        return 4.50 + peso_kg * 0.75

    def prazo_em_dias(self, cep):
        return

    def codigo_rastreio(self):
        return "OLHE-PARA-O-CEU"


class CarrocaDeBoi(Entrega):
    def calcular_frete(self, peso_kg, cep):  # nao usa o cep
        return 9.90 + peso_kg * 0.40

    def prazo_em_dias(self, cep):  # nao usa o cep
        return 30

    def codigo_rastreio(self):
        return "BOI-0404"
```

Tudo isso converge pro método onde o professor usa os termos como *code smell* e *god class*: `ProcessadorDePedido.processar` calcula subtotal, aplica desconto, calcula peso, decide a entrega, calcula frete e imposto, valida cartão, grava em "banco", manda e-mail, imprime nota fiscal e loga — tudo junto, num só lugar:

```python
class ProcessadorDePedido:
    def processar(self, pedido):
        subtotal = 0
        for item in pedido.itens:
            subtotal = subtotal + item.cacto.preco * item.quantidade

        desconto = 0
        if pedido.cupom is not None:
            if pedido.cupom == "NULLSAFE10":
                desconto = subtotal * 0.10
            elif pedido.cupom == "OFFBYONE5":
                desconto = 5.0
            elif pedido.cupom == "HELLOWORLD":
                desconto = subtotal * 0.15
                if desconto > 40.0:  # if devia ta pra fora desse elif
                    desconto = 40.0

        peso_kg = 0
        for item in pedido.itens:
            peso_kg = peso_kg + item.quantidade * (item.cacto.altura_cm * 0.05)

        if pedido.tipo_entrega == "SEDEX":
            entrega = Sedex()
        elif pedido.tipo_entrega == "DRONE":
            entrega = Drone()
        elif pedido.tipo_entrega == "POMBO":
            entrega = PomboCorreio()
        elif pedido.tipo_entrega == "CARROCA":
            entrega = CarrocaDeBoi()
        else:
            entrega = Sedex()  # talvez o sedex n entregue nesse lugar, tem q verificar

        frete = entrega.calcular_frete(peso_kg, pedido.cep)
        base_imposto = subtotal - desconto
        imposto = base_imposto * 0.18
        total = base_imposto + frete + imposto

        if pedido.numero_cartao is None or len(pedido.numero_cartao) != 16:
            raise ValueError("cartao invalido")
        soma = 0
        for c in pedido.numero_cartao:
            if c < "0" or c > "9":
                raise ValueError("cartao invalido")
            soma = soma + int(c)
        if soma % 10 != 0:
            raise ValueError("cartao recusado")

        sql = (
            "INSERT INTO pedidos (cliente, cep, entrega, total) VALUES ('"
            + pedido.cliente + "', '" + pedido.cep + "', '" + pedido.tipo_entrega
            + "', " + f"{total:.2f}" + ")"
        )
        print("[BANCO] " + sql)
        for item in pedido.itens:
            print(
                "[BANCO] INSERT INTO itens (pedido_cliente, cacto, qtd) VALUES ('"
                + pedido.cliente + "', '" + item.cacto.nome + "', "
                + str(item.quantidade) + ")"
            )

        corpo = "<html><body>"
        corpo = corpo + "<h1>Obrigado, " + pedido.cliente + "!</h1>"
        corpo = corpo + "<p>Seus cactos foram compilados sem warnings e entraram na fila de deploy.</p><ul>"
        for item in pedido.itens:
            corpo = corpo + "<li>" + str(item.quantidade) + "x " + item.cacto.nome + "</li>"
        corpo = corpo + "</ul><p>Frete: R$ " + f"{frete:.2f}" + "</p>"
        corpo = corpo + "<p>Total: R$ " + f"{total:.2f}" + "</p>"
        corpo = corpo + "<p>Previsao de entrega: " + str(entrega.prazo_em_dias(pedido.cep)) + " dias</p>"
        corpo = corpo + "</body></html>"
        print("[SMTP] enviando para " + pedido.email)
        print(corpo)

        print("=== NOTA FISCAL ELETRONICA ===")
        print("DESTINATARIO: " + pedido.cliente)
        print("BASE DE CALCULO: " + f"{base_imposto:.2f}")
        print("ICMS 18%: " + f"{imposto:.2f}")
        print("VALOR TOTAL: " + f"{total:.2f}")
        print("==============================")

        print(
            "[LOG] pedido de " + pedido.cliente + " processado com "
            + str(len(pedido.itens)) + " itens, total " + f"{total:.2f}"
        )

        return total
```
Pinho também disse que 'quanto mais você precisa dar scroll numa função, pior ela é', 'código longo com variáveis pouco significativas é ruim de manter' e é 'pouco provável que você realmente precise de uma classe com $1000$ linhas' (fazendo referência a um código em produção real).


== Por que o `processar` deveria ser vários métodos (SRP)

O problema dessa função é que ela tem várias (funções). Se listassemos, quem, na empresa, poderia pedir uma mudança em `ProcessadorDePedido.processar` — e apontando exatamente onde, dentro do método, cada um bateria:

- a *contabilidade* precisar mudar a alíquota — o `0.18` fixo em `imposto = base_imposto * 0.18`;
- o *marketing* criar um cupom novo — o bloco `if pedido.cupom == "NULLSAFE10": ...` 
- o *marketing* precisar mudar o e-mail — o bloco que monta `corpo` em HTML e manda pro "SMTP";
- o *gateway do cartão* mudar — a validação de `numero_cartao` (tamanho, dígitos, soma);
- o *DBA* precisar mudar uma coluna — o `sql = "INSERT INTO pedidos ..."` montado por concatenação de string (que, à parte da aula, também é uma porta aberta pra SQL injection, já que `pedido.cliente` entra direto na query sem tratamento nenhum);
- o *SEFAZ* mudar o layout da nota — o bloco `"=== NOTA FISCAL ELETRONICA ==="`;
- os *Correios* mudarem o modo de calcular o peso — a fórmula `peso_kg = peso_kg + item.quantidade * (item.cacto.altura_cm * 0.05)`;
- o *COO* querer oferecer outra forma de envio — o `if`/`elif` de `tipo_entrega`.

É esse problema que o Princípio de Responsabilidade Única (SRP) corrige: cada componente deve apresentar uma única responsabilidade. É o primeiro dos cinco princípios do SOLID.

== Loja (exercício de correção) <cod-aula1>

O professor exemplifica a solução numa loja simplificada que faz somente o frete, produto e recibo, pra refatorar passo a passo. A etapa 1 comete o mesmo erro numa escala menor: 


```python
class Loja1:
    def processar(self, cliente, valor, peso_kg, centro):
        if centro == 'Sao Paulo':
            frete = 10.0 + 2.0 * peso_kg
        elif centro == 'Manaus':
            frete = 25.0 + 1.2 * peso_kg
        else:
            frete = 10.0 + 2.0 * peso_kg

        total = valor + frete
        return f'{cliente} pagou R$ {total:.2f} (envio de  {centro})'
```

A etapa 2 divide `Loja1` em peças, cada uma cuidando de uma única coisa — calcular o total, gerar o recibo, e decidir o custo do frete, com uma subclasse por tipo de frete:

```python
class Frete(ABC):
    @abstractmethod
    def custo(self, peso_kg):
        ...

class FreteRodoviario(Frete):
    def custo(self, peso_kg):
        return 10.0 + 2.0 * peso_kg

class FreteFluvial(Frete):
    def custo(self, peso_kg):
        return 25.0 + 1.2 * peso_kg

class CalculadoraTotal:
    def total(self, valor, frete):
        return valor + frete

class Recibo:
    def gerar(self, cliente, total, centro):
        return f'{cliente} pagou R$ {total:.2f} (envio de  {centro})'


class Loja2:
    def __init__(self, calculadora, recibo):
        self.calculadora = calculadora
        self.recibo = recibo

    def processar(self, cliente, valor, peso_kg, centro):
        if centro == 'Sao Paulo':
            frete = FreteRodoviario()
        elif centro == 'Manaus':
            frete = FreteFluvial()
        else:
            frete = FreteRodoviario()

        total = self.calculadora.total(valor, frete.custo(peso_kg))

        return self.recibo.gerar(cliente, total, centro)
```

Agora, `Loja2` ainda tem um `if`, decidindo qual objeto usar, mas não faz mais o cálculo do frete nem monta o recibo. Rodando as duas etapas lado a lado, o resultado é o mesmo, mas a segunda já está pronta pra crescer sem precisar reescrever tudo de novo:

```python
cliente = 'Ada'
valor = 100
peso_kg = 2

print('etapa 1 - tudo cagado')
loja1 = Loja1()
print(loja1.processar(cliente, valor, peso_kg, 'Sao Paulo'))
print(loja1.processar(cliente, valor, peso_kg, 'Manaus'))

print('etapa 2 - SRP dominado')
loja2 = Loja2(CalculadoraTotal(), Recibo())
print(loja2.processar(cliente, valor, peso_kg, 'Sao Paulo'))
print(loja2.processar(cliente, valor, peso_kg, 'Manaus'))
```

== Termos da Aula 1
- *Docstring, typehint* - Vocês já sabem isso;
- *Design by contract* — declarar o comportamento esperado de um componente (o que ele espera receber, o que garante devolver) e confiar nisso, em vez de reverificar tudo em tempo de execução.
- *Defeito (fault/bug)* — falha concreta e localizável no código-fonte, que existe independente de ser executada.
- *Falha (failure)* — comportamento incorreto observável quando o programa roda e um defeito é de fato acionado.
- *Code smell* — sintoma de que o design do código está ruim, mesmo funcionando sem erros; o "cheiro" de um problema estrutural.
- *God class* — classe (ou método) que sabe e faz coisas demais, concentrando responsabilidades que deveriam estar separadas.
- *SRP (Princípio de Responsabilidade Única)* — cada componente deve ter um único motivo pra mudar; o S do SOLID.


= Aula 2 - Simple Factory, Factory Method e OCP

#v(0.9cm)

A solução da `Loja2` (@cod-aula1) resolveu o SRP, mas o `if centro == ...` continua dentro de `processar`, decidindo qual `Frete` instanciar ainda hardcoded, ainda fazendo verificação de string, o que ainda é problema mesmo depois do SRP resolvido (Professor disse que deixar essas verificações em string é um crime, mas não vem ao caso). Some a isso uma regra de negócio nova: a loja quer simular o frete antes da compra, não só calculá-lo depois que o cliente já decidiu comprar, e passa a atender mais centros de distribuição. Dessa forma, agora, vários lugares diferentes vão precisar da mesma lógica de "qual frete usar para este centro", e ela está presa dentro de `Loja2`.

== Simple Factory

Simple Factory resolve o problema das classes: tira o `if` de dentro da loja e concentra numa única classe. A ideia, resumida em aula, é simplesmente mudar o if de lugar:

```python
class FabricaDeFrete:
    def criar(self, centro):
        if centro == 'Sao Paulo':
            return FreteRodoviario()
        elif centro == 'Manaus':
            return FreteFluvial()
        else:
            return FreteRodoviario()


class SimuladorDeFrete:
    def __init__(self, fabrica):
        self.fabrica = fabrica

    def simular(self, centro, peso_kg):
        return self.fabrica.criar(centro).custo(peso_kg)


class Loja3:
    def __init__(self, fabrica, calculadora, recibo):
        self.fabrica = fabrica
        self.calculadora = calculadora
        self.recibo = recibo

    def processar(self, cliente, valor, peso_kg, centro):
        frete = self.fabrica.criar(centro)
        total = self.calculadora.total(valor, frete.custo(peso_kg))
        return self.recibo.gerar(cliente, total, centro)
```
Agora, a loja não precisa mais entender de frete. O ganho aparece em isolar o if do resto do código: o acoplamento entre `Loja` e a lógica de frete diminui. Pinho disse isso numa frase: 'toda vez que uma mudança no código não obriga o `main` a mudar junto, o design melhorou'. De fato, a etapa 3 do `main` só precisa montar a fábrica e injetá-la:

```python
print("ETAPA 3 - SRP simple factory")
fabrica = FabricaDeFrete()
loja3 = Loja3(fabrica, CalculadoraTotal(), Recibo())
print(loja3.processar(cliente, valor, peso_kg, 'Sao Paulo'))
print(loja3.processar(cliente, valor, peso_kg, 'Manaus'))
custo = SimuladorDeFrete(fabrica).simular("Belém", peso_kg)

print("Simulação Belém", custo)
```

Note que essa última linha ainda esconde o mesmo bug do `else`. Como `FabricaDeFrete.criar` só reconhece `'Sao Paulo'` e `'Manaus'`, simular pra "Belém" cai no `else` e devolve `FreteRodoviario`, o que pode não ser o certo pro caso.

Nesse ponto a aula sai do código e coloca o Simple Factory dentro de um vocabulário maior de arquitetura. O professor ajuda a definir alguns termos, que vou definir melhor aqui, não exatamente do jeito dito: um *padrão de projeto* é uma saída clássica, já testada, para um problema recorrente de modelagem; a referência dada foi o livro de 1994 do *GoF* (Gang of Four). 

O GoF organiza os 23 padrões do livro de 1994 em três famílias: *padrões criacionais* (como criar objetos — Factory Method, Abstract Factory, Builder, Prototype, Singleton), *padrões estruturais* (como compor classes e objetos — Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy) e *padrões comportamentais* (como objetos interagem e distribuem responsabilidade — Observer, Strategy, State, Template Method, entre outros). O Simple Factory é um idioma didático, usado como degrau pra chegar no Factory Method — esse sim um dos criacionais reconhecidos pelo GoF.

== Factory Method

O Simple Factory ainda tem um `if` central, só que concentrado num único lugar. Em vez de uma fábrica perguntar "qual centro é esse?", cada centro de distribuição sabe, por si mesmo, qual frete criar — quem entrega essa decisão ao código passa a ser a própria classe do centro de distribuição. Isso é feito com um método abstrato que cada subclasse implementa à sua maneira, uma por centro (faz isso importando o decorador e passando o decorador a função e a classe a própria factory - é um método declarado sem corpo ou código de execução, que serve como uma regra obrigatória para que as classes filhas criem sua própria implementação). Vejamos no exemplo:

```python
class CentroDeDistribuicao(ABC):
    def __init__(self, cidade, calculadora, recibo):
        self.cidade = cidade
        self.calculadora = calculadora
        self.recibo = recibo

    @abstractmethod
    def criar_frete(self):
        ...

    def despachar(self, cliente, valor, peso_kg):
        frete = self.criar_frete()
        total = self.calculadora.total(valor, frete.custo(peso_kg))
        return self.recibo.gerar(cliente, total, self.cidade)


class CentroSaoPaulo(CentroDeDistribuicao):
    def __init__(self, calculadora, recibo):
        super().__init__("São Paulo", calculadora, recibo)

    def criar_frete(self):
        return FreteRodoviario()


class CentroManaus(CentroDeDistribuicao):
    def __init__(self, calculadora, recibo):
        super().__init__("Manaus", calculadora, recibo)

    def criar_frete(self):
        return FreteFluvial()


class CentroBelem(CentroDeDistribuicao):
    def __init__(self, calculadora, recibo):
        super().__init__("Belém", calculadora, recibo)

    def criar_frete(self):
        return FreteFluvial()
```

Agora, Belém tem, por conta própria, o frete fluvial certo — sem precisar tocar em nenhum `if`. O restante do fluxo (calcular total, gerar recibo) fica implementado uma única vez, no método concreto `despachar` da classe-base — as subclasses só precisam dizer qual frete usar. O polimorfismo (significa "muitas formas" (no caso, a função criar_frete é a polimórfica)) substitui o `if`: quando o código chama `self.criar_frete()`, quem responde já é o objeto do centro certo, decidido no momento em que a classe foi escolhida (a instanciação), não dentro de um `if` em tempo de execução. Essa é a etapa 4:

```python
print("ETAPA 4")
sao_paulo = CentroSaoPaulo(CalculadoraTotal(), Recibo())
manaus = CentroManaus(CalculadoraTotal(), Recibo())
belem = CentroBelem(CalculadoraTotal(), Recibo())
print(sao_paulo.despachar(cliente, valor, peso_kg))
print(manaus.despachar(cliente, valor, peso_kg))
print(belem.despachar(cliente, valor, peso_kg))
```

O mesmo raciocínio vale pra produtos: pra cada produto novo que precise de fábrica própria, o padrão pede duas classes, o produto e a fábrica do produto (aqui, o "produto" é o `Frete`, e a "fábrica" é o próprio `CentroDeDistribuicao`).

Comparado ao Simple Factory, adicionar um centro de distribuição novo passa a significar *criar* uma subclasse, e não editar nenhuma existente: nada do código antigo precisou mudar pra isso, nem o `CentroDeDistribuicao` já existente precisou ser tocado pra nascer um tipo novo. Esse é, literalmente, o enunciado do Open/Closed Principle, o O do SOLID: uma classe deve estar fechada para modificação e aberta para extensão. 

== Termos da Aula 2

- *Simple Factory* — classe cujo único trabalho é decidir qual objeto concreto criar, tirando essa decisão de quem consome o objeto.
- *Padrão de projeto (design pattern)* — solução clássica e já testada pra um problema recorrente de modelagem orientada a objetos; catalogados no livro do GoF (1994).
- *GoF (Gang of Four)* — apelido dos quatro autores do livro *Design Patterns* (1994).
- *Padrão criacional* — categoria de padrão de projeto que resolve "qual é a forma correta de criar um objeto" (Simple Factory, Factory Method, Builder, Singleton).
- *Factory Method* — cada subclasse decide, via método abstrato sobrescrito, qual objeto concreto criar; substitui o if por polimorfismo.
- *Polimorfismo* — objetos de subclasses diferentes respondem à mesma chamada de método, cada um à sua maneira.
- *OCP (Open/Closed Principle)* — uma classe deve estar fechada para modificação e aberta para extensão; o O do SOLID.


= Aula 3 - Builder e Singleton

== Builder

O padrão de criação Builder fala sobre esconder a complexidade de montar um (ou vários (do mesmo)) objeto. O exemplo dado foi fazer uma requisição HTTP (você precisa de url, header, token, body), ou uma consulta SQL via ORM, com schema, select, from, where: linhas e mais linhas só pra montar uma chamada, o que não é gerenciável e dificulta a leitura pra quem lê depois. 

Para resolver isso, cria-se uma classe específica só pra construir objetos de um tipo (nomeada normalmente como `{Produto}Builder`), onde cada decisão de criação complexa fica dentro dessa classe, e o objetivo é fazer decisões encadeadas (retornando o self a cada método do Builder). 

O exemplo de aula foi montar um computador:

```python
class Computador:
    def __init__(self):
        self.processador = None
        self.memoria_gb = None
        self.armazenamento_gb = None
        self.placa_video = None

    def __str__(self):
        return f'Processador: {self.processador}, Memória: {self.memoria_gb}, Armazenamento: {self.armazenamento_gb} e Placa de Vídeo {self.placa_video}'


class ComputadorBuilder:
    def __init__(self):
        self.computador = Computador()

    def com_processador(self, processador):
        self.computador.processador = processador
        return self

    def com_memoria_gb(self, memoria_gb):
        self.computador.memoria_gb = memoria_gb
        return self

    def com_armazenamento_gb(self, armazenamento_gb):
        self.computador.armazenamento_gb = armazenamento_gb
        return self

    def com_placa_video(self, placa_video):
        self.computador.placa_video = placa_video
        return self

    def construir(self):
        return self.computador


computador_gamer = (
    ComputadorBuilder()
    .com_processador('Intel I7')
    .com_memoria_gb('16 GB RAM')
    .com_armazenamento_gb('1024')
    .com_placa_video('Nvd 5070')
    .construir()
)
```

Cada propriedade de construção difícil vira um método que devolve `self`, enquanto o resto fica no `__init__` de `Computador`. Todos os métodos do builder fazem isso, com exceção do `.construir()`, que é quem devolve o produto final já pronto. Na vida real você raramente monta um computador atributo por atributo toda vez: normalmente existe uma classe com as construções comuns já prontas (configurações padrão), reaproveitando o mesmo builder por baixo:

```python
# na vida real criamos objetos padrão
# muitas vezes vamos ter uma classe com todas as construções comuns que precisamos (configurações prontas)
class InfoCentro:
    def montar_computador_basico(self):
        return (
            ComputadorBuilder()
            .com_processador('Intel I3')
            .com_memoria_gb('8 GB RAM')
            .com_armazenamento_gb('256')
            .com_placa_video('Integrada')
            .construir()
        )

    def montar_computador_gamer(self):
        return (
            ComputadorBuilder()
            .com_processador('Intel I7')
            .com_memoria_gb('16 GB RAM')
            .com_armazenamento_gb('1024')
            .com_placa_video('Nvd 5070')
            .construir()
        )

```

Para esse exemplo, fiquei com a dúvida: qual a utilidade do Builder se eu podia simplesmente instanciar `Computador` passando as especificações direto (ou, se precisasse, colocar a classe `Computador` diretamente dentro de uma classe principal (como a `InfoCentro`))? Nesse caso, a resposta é: nenhuma, ou quase. `Computador(processador='Intel I7', memoria_gb='16 GB RAM', armazenamento_gb='1024', placa_video='Nvd 5070')` faz exatamente o mesmo que as cinco linhas encadeadas do `ComputadorBuilder`, com menos código e sem precisar de uma classe extra. O motivo é que o Builder clássico nasceu pra resolver o problema do construtor telescópico, em que pular um parâmetro opcional te obrigava a passar `null` pra todos os anteriores na ordem certa. Nós não conseguimos enxergar esse problema pois o Python já resolve isso de fábrica com `kwargs` e parâmetros nomeados (colocar `parametro = valor_padrao`).

O Builder só ganha da alternativa direta quando o que está sendo montado não é só um punhado de campos escalares: é o caso dos dois exemplos que abriram a aula, montar um request HTTP ou uma query SQL, onde você vai *acumulando* uma quantidade variável de coisas (headers, cláusulas `where`) em vez de preencher campos fixos, ou quando um passo depende do resultado de outro (validar se a fonte de energia aguenta a placa de vídeo escolhida, por exemplo), ou quando você quer impedir que um objeto pela metade escape pro resto do código. 

Um exemplo concreto onde o Builder faz sentido, voltando pro domínio da Cacto: montar a consulta de pedidos com um número variável de filtros, onde cada `.com_X()` só entra na query se o chamador realmente pedir aquele filtro.

```python
class ConsultaPedidosBuilder:
    def __init__(self):
        self.tabela = "pedidos"
        self.condicoes = []
        self.parametros = []

    def com_cliente(self, cliente):
        self.condicoes.append("cliente = %s")
        self.parametros.append(cliente)
        return self

    def com_tipo_entrega(self, tipo_entrega):
        self.condicoes.append("tipo_entrega = %s")
        self.parametros.append(tipo_entrega)
        return self

    def com_total_minimo(self, total_minimo):
        self.condicoes.append("total >= %s")
        self.parametros.append(total_minimo)
        return self

    def construir(self):
        sql = f"SELECT * FROM {self.tabela}"
        if self.condicoes:
            sql += " WHERE " + " AND ".join(self.condicoes)
        return sql, self.parametros


sql, parametros = (
    ConsultaPedidosBuilder()
    .com_tipo_entrega("DRONE")
    .com_total_minimo(100.0)
    .construir()
)
# sql = 'SELECT * FROM pedidos WHERE tipo_entrega = %s AND total >= %s'
# parametros = ['DRONE', 100.0]
```

Um kwarg fixo não dá conta disso de forma limpa — teria que ser algo como `consultar(cliente=None, tipo_entrega=None, total_minimo=None)` com um `if` pra cada parâmetro checando se é `None` antes de colar no SQL, o que é exatamente a bagunça que o Builder organiza aqui. E de quebra, essa versão já resolve o problema de SQL injection apontado lá na Cacto: em vez de concatenar `pedido.cliente` direto na string, os valores viram parâmetros separados (`%s` + lista `parametros`), passados pro driver do banco em vez de virarem texto da query.

== Singleton

Singleton parte de um problema oposto: em vez de facilitar criar vários objetos, ele impede que exista mais de um. Só podemos ter uma instância na aplicação, impossível ter um segundo objeto. A analogia dada em aula: é como colocar um assento onde só cabe uma pessoa. Um nome comum pra esse tipo de classe é `Config`, embora o exemplo em si não implemente nenhum método de negócio, só o mecanismo. 

=== Singleton no `__new__`
A primeira forma de resolver isso funciona em qualquer linguagem orientada a objetos (existe outro jeito, mas só funciona em Python) e mexe direto no `__new__`:

```python
from typing import ClassVar, Self


class SingletonNew:
    _instance: ClassVar[SingletonNew | None] = None

    def __new__(cls) -> Self:
        if cls._instance is None:
            print('[SingletonNew] Criando Nova instância')
            cls._instance = super().__new__(cls)
        else:
            print('[SingletonNew] Retornando instância existente!')

        return cls._instance

    def __init__(self):
        self.data: str = 'Shared Resource'


print(SingletonNew() is SingletonNew())
```

Essa solução também pode ser misturada com Builder e outros padrões — o código acima é só o esqueleto, poderia ter métodos de negócio como qualquer classe normal. Só que, como dito pelo Pinho, a solução não é boa: toda vez que você instancia `SingletonNew()`, o `__init__` roda de novo mesmo quando `__new__` está devolvendo a instância antiga — o estado se torna repetido sempre, mesmo sem criar um objeto novo. E pior: com herança, o Singleton se duplica. Se uma classe filha herda de uma classe mãe que já implementa esse `__new__`, a classe filha acaba pegando o singleton da classe mãe. Não dá pra usar essa estratégia no `__new__` de forma confiável quando existe hierarquia.

=== Singleton no decorador

A segunda forma tenta resolver isso com um decorador, guardando cada instância criada num dicionário — em vez de uma cadeira, um banco com vários lugares, um pra cada tipo de classe decorada:

```python
from collections.abc import Callable
from typing import Any


def singleton_naive[T](cls: type[T]) -> Callable[..., T]:
    instances: dict[type[T], T] = {}

    def get_instance(*args: Any, **kwargs: Any) -> T:
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]

    return get_instance


@singleton_naive
class SingletonNaive:
    '''Singleton sem uma preocupação terrível'''

    def __init__(self, rotulo: str = 'Sem algo que seria útil aqui') -> None:
        self.rotulo = rotulo


print(type(SingletonNaive))
print(SingletonNaive().__name__, SingletonNaive().__doc__)
```

O problema aqui é de outra natureza: `get_instance` deveria receber tudo que o construtor da classe original receberia, mas como o decorador funciona pra qualquer classe, ele não tem como saber de antemão o que cada uma espera. E tem um efeito colateral mais sério — depois do decorador, `SingletonNaive` deixa de ser uma classe e passa a ser uma função (`get_instance`, guardada como closure, com `cls` capturado como freevar no frame da função original). Isso significa que um `isinstance` contra `SingletonNaive` já não funciona mais do jeito esperado, porque você estaria comparando contra uma função, não contra um tipo. O singleton em si funciona perfeitamente, mas a classe não funciona mais perfeitamente como classe.

== Termos da Aula 3

- *Builder* — padrão criacional que isola a lógica de montar um objeto complexo numa classe própria, com métodos encadeados.
- *Singleton* — padrão criacional que garante que uma classe tenha, no máximo, uma única instância na aplicação.
- *Closure* — função que "lembra" variáveis do escopo onde foi definida, mesmo depois que esse escopo termina de executar.
- *Freevar (variável livre)* — variável usada dentro de uma função mas definida fora dela, capturada pela closure.

= quinta

quero fazer um widget de calendario e clima
criando fabrica de elemento de interface
fabrica concreta das fabricas
separa em ipad e ios
ao escolher uma fabrica, todo o restante do programa se adequa a ela 
geração de widgets de acordo com osistema operacional
mas ainda tá desconexo
aqui tem uns ifs
fabricas concretas de cada familia
todos os produtos de todas as familias são tratados como genéricos


```python
"""
A Abstract Factory (Fábrica Abstrata) é um padrão de projeto criacional que permite
produzir famílias de objetos relacionados ou dependentes sem especificar suas classes concretas.

Importante:
As classes de Abstract Factory frequentemente são baseadas em um conjunto de Factory Methods, mas também é possível usar Prototype para compor os métodos dessas classes. Mas, como a turma conhece Factory Methods, vou seguir esta abordagem
"""

from abc import ABC, abstractmethod

class UIFactory(ABC):
	@abstractmethod
	def create_calendar(self): ...

	@abstractmethod
	def create_weather(self): ...

class iPadOSFactory(UIFactory):
	def create_calendar(self):
		print("Factory da Plataforma iPadOS: Calendário")
		iPadOSCalendarWidget().create_calendar()

	def create_weather(self):
		print("Factory da Plataforma iPadOS: Clima")
		iPadOSWeatherWidget().create_weather()

class iOSFactory(UIFactory):
	def create_calendar(self):
		print("Factory da Plataforma iOS: Calendário")
		iOSCalendarWidget().create_calendar()

	def create_weather(self):
		print("Factory da Plataforma iOS: Clima")
		iOSWeatherWidget().create_weather()

####################

class CalendarWidget(ABC):
	@abstractmethod
	def create_calendar(self): ...

class iPadOSCalendarWidget(CalendarWidget):
	def create_calendar(self):
		print("Criando um calendário para iPadOS")

class iOSCalendarWidget(CalendarWidget):
	def create_calendar(self):
		print("Criando um calendário para iOS")

####################

class WeatherWidget(ABC):
	@abstractmethod
	def create_weather(self): ...

class iPadOSWeatherWidget(WeatherWidget):
	def create_weather(self):
		print("Criando um painel climático para iPadOS")

class iOSWeatherWidget(WeatherWidget):
	def create_weather(self):
		print("Criando um painel climático para iOS")
		
####################

class ApplicationInterface:
	def get_factory(self, platform_type):
		if platform_type == "iPadOS":
			return iPadOSFactory()
		if platform_type == "iOS":
			return iOSFactory()
		
		raise ValueError("Esta plataforma não existe")

####################

application_interface = ApplicationInterface()

# Platform type can be read from config file etc.
print("#"*40)

print("***** iPadOS *****")
widget_factory = application_interface.get_factory("iPadOS")
widget_factory.create_calendar()
widget_factory.create_weather()
print("#"*40)

print("***** iOS *****")
widget_factory = application_interface.get_factory("iOS")
widget_factory.create_calendar()
widget_factory.create_weather()
print("#"*40)

###############################################################################

from abc import ABC, abstractmethod

# ============================================================
# The Abstract Factory  is a creational design pattern that allows producing families
# of related or dependent objects without specifying their concrete classes.
#
# Abstract Factory classes are often based on a set of Factory Methods, but you can also use 
# Prototype to compose the methods on these classes.
#
# For this lesson, we will use the Factory Methods approach
# ============================================================

# ============================================================
# 1) ABSTRAÇÕES (produtos) - o cliente conhece apenas isso
# ============================================================

class DatasetLoader(ABC):
    @abstractmethod
    def load(self) -> None: ...

class Model(ABC):
    @abstractmethod
    def train(self) -> None: ...

class Visualizer(ABC):
    @abstractmethod
    def plot(self) -> None: ...

# ============================================================
# 2) ABSTRAÇÃO DA FÁBRICA - contrato da família de produtos
# ============================================================

class DataScienceFactory(ABC):
    @abstractmethod
    def create_dataset_loader(self) -> DatasetLoader: ...

    @abstractmethod
    def create_model(self) -> Model: ...

    @abstractmethod
    def create_visualizer(self) -> Visualizer: ...

# ============================================================
# 3) PRODUTOS CONCRETOS - Família Local (Pandas / Sklearn / Matplotlib)
# ============================================================

class PandasDatasetLoader(DatasetLoader):
    def load(self) -> None:
        print("[PandasDatasetLoader] Lendo CSV local com pandas.read_csv(...). Amostras: 10_000")

class SklearnModel(Model):
    def train(self) -> None:
        print("[SklearnModel] Treinando LogisticRegression(solver=\"lbfgs\"). Acurácia de validação: 0.89")

class MatplotlibVisualizer(Visualizer):
    def plot(self) -> None:
        print("[MatplotlibVisualizer] Plotando curva ROC e matriz de confusão com Matplotlib.")


# ============================================================
# 4) PRODUTOS CONCRETOS - Família Distribuída (Spark / MLlib / Seaborn)
# ============================================================

class SparkDatasetLoader(DatasetLoader):
    def load(self) -> None:
        print("[SparkDatasetLoader] Lendo dados no cluster: spark.read.parquet(\"s3://bucket/dataset\"). Linhas: 120_000_000")

class MLlibModel(Model):
    def train(self) -> None:
        print("[MLlibModel] Treinando RandomForestClassifier em cluster (MLlib). AUC de validação: 0.92")

class SeabornVisualizer(Visualizer):
    def plot(self) -> None:
        print("[SeabornVisualizer] Gerando pairplot e heatmap de correlação com Seaborn.")

# ============================================================
# 5) FÁBRICAS CONCRETAS - produzem uma FAMÍLIA coerente de produtos
# ============================================================

class LocalPandasFactory(DataScienceFactory):
    """Família "local" para dados pequenos/medianos."""
    def create_dataset_loader(self) -> DatasetLoader:
        print("[LocalPandasFactory] -> criando DatasetLoader (Pandas)")
        return PandasDatasetLoader()

    def create_model(self) -> Model:
        print("[LocalPandasFactory] -> criando Model (Scikit-learn)")
        return SklearnModel()

    def create_visualizer(self) -> Visualizer:
        print("[LocalPandasFactory] -> criando Visualizer (Matplotlib)")
        return MatplotlibVisualizer()

class DistributedSparkFactory(DataScienceFactory):
    """Família "distribuída" para grandes volumes de dados."""
    def create_dataset_loader(self) -> DatasetLoader:
        print("[DistributedSparkFactory] -> criando DatasetLoader (Spark)")
        return SparkDatasetLoader()

    def create_model(self) -> Model:
        print("[DistributedSparkFactory] -> criando Model (MLlib)")
        return MLlibModel()

    def create_visualizer(self) -> Visualizer:
        print("[DistributedSparkFactory] -> criando Visualizer (Seaborn)")
        return SeabornVisualizer()

# ============================================================
# 6) "SELETOR" DE FÁBRICA - ponto único de decisão concreta
#    (poderia vir de config/env/CLI; mantido simples para aula)
# ============================================================

class ApplicationInterface:
    def get_factory(self, stack: str) -> DataScienceFactory:
        """
        stack: "local" ou "distributed"
        Retorna a fábrica apropriada, sem expor classes concretas ao restante do cliente.
        """
        if stack == "local":
            print("[ApplicationInterface] Selecionando família LOCAL (Pandas/Sklearn/Matplotlib)")
            return LocalPandasFactory()
        if stack == "distributed":
            print("[ApplicationInterface] Selecionando família DISTRIBUÍDA (Spark/MLlib/Seaborn)")
            return DistributedSparkFactory()
        raise ValueError("Stack inválida. Use \"local\" ou \"distributed\".")


# ============================================================
# 7) DRIVER CODE
# ============================================================

app = ApplicationInterface()

# ---- Execução com a família LOCAL ----
print("\n===== Cenário A: Pipeline LOCAL (dados pequenos/medianos) =====")
factory = app.get_factory("local")                      # cliente recebe a FÁBRICA (abstração)
loader = factory.create_dataset_loader()                # abstração DatasetLoader
modelo = factory.create_model()                         # abstração Model
viz = factory.create_visualizer()                       # abstração Visualizer

print("\n[Cliente] Executando pipeline LOCAL (mesmo cliente, família 1):")
loader.load()
modelo.train()
viz.plot()

# ---- Troca de fábrica em tempo de execução (sem mudar o cliente) ----
print("\n===== Cenário B: Pipeline DISTRIBUÍDO (big data) =====")
factory = app.get_factory("distributed")                # troca a família
loader = factory.create_dataset_loader()
modelo = factory.create_model()
viz = factory.create_visualizer()

print("\n[Cliente] Executando pipeline DISTRIBUÍDO (mesmo cliente, família 2):")
loader.load()
modelo.train()
viz.plot()
```

aqui estamos criando um cara pra carregar dataset, rodar modelo, e visualizar resposta
analitica diagnostia podia ser assim
classe abstrata define um comportamento da class (modelo, dataset, visualizacao)

mais uma classe com 3 metodos,
a fabrica cria as mesmas classes, com as funções definidas antes
usuario so precisa conhecer as abstrações das nossas fábricas
se usa muito mais o abstract factory do que o factory method (porque?)
voce pode criar quantos loaders vcs quiser, quantos modelos vcs quiserem.
a fabrica local de pandas tem a mesma estrutura do datscience factory
pra mudar, você só precisa pegar a classe de Modelo.
voce criou a classe inteira e só precisa mudar na linha de SkLearn
a única decisão do usuário é escolher a fabrica que ele quer?

como estruturar essa quantidade de classes
se vc mudar a estrutura vc muda o padrãoo que que pode mudar a vontade é acrescentar classes
vc (não) pode mudar classes concretas


voltando ao exemplo da loja
testes de regressão
se eu quiser ter uma calculadora de frete e recibo diferente pra cada estado, o que fazer?
se quiser evoluir, usa um abstractfactory nelas
cria factory method na calculadora e no recibo, e  o abstractfactory nos centrossingleton de fabricadefrete
OCP
se a gente quiser colocar belem no frete aereo

pra faze isso, teriamos que estender de Frete, sem precisar modificar só estendendo.
copia o fretefluvial e bota aereo
