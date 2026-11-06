#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#import "@preview/codly:2.0.0" as codly
#import "@preview/codly-languages:0.1.8": *
#show: codly.theme("thesis")


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

  João Pedro Jerônimo
]

#align(horizon + center)[
  #text(17pt)[
    Engenharia de Software
  ]

  #text(14pt)[
    Revisão para A2
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2026
]

#pagebreak()

#block(
  width: 100%,
  fill: rgb(255, 148, 162),
  inset: 1em,
  stroke: 1.5pt + rgb(117, 6, 21),
  radius: 5pt
)[
  *Nota*: Os conteúdos sobre Design Patterns foram retirados e adaptados/traduzidos da página #link("https://refactoring.guru/pt-br", "Refactoring Guru") em conjunto com códigos elaborados por conta própria e/ou retirados das aulas do professor. O conteúdo sobre SOLID foi retirado e adaptado das aulas e de sites diversos na internet.
]


// ============================ PÁGINAS POSTERIORES =========================
#outline(title: "Conteúdo")

#pagebreak()

#align(center+horizon)[
  = SOLID - L e I
]

#pagebreak()

== L - Princípio da Substituição de Liskov
O Princípio da Substituição de Liskov (Liskov Substitution Principle - LSP) é um dos cinco princípios do SOLID. O LSP afirma que objetos de uma classe derivada devem poder substituir objetos da classe base *sem alterar a corretude do programa*. Em outras palavras, se uma classe S é uma subclasse de T, então objetos de tipo T podem ser substituídos por objetos de tipo S sem afetar o comportamento esperado do programa.

Imagine que uma empresa criou, internamente, um programa para atender a *todos* os seus usuários. Obviamente, ela vai utilizar da classe base `Usuario` para essa representação. No entanto, em uma empresa madura, com toda certeza vai existir algum tipo de *especialização* de usuários para atender às necessidades da empresa. Para continuar o exemplo, vamos supor a seguinte estrutura:

#codly.new(

file: "users.py",

```python
class Usuario(ABC):
  @abstractmethod
  def gerar_relatorio(self):
    ...

class UsuarioComercial(Usuario):
  def gerar_relatorio(self):
    print("Gerando relatório comercial...")

class UsuarioFinanceiro(Usuario):
  def gerar_relatorio(self):
    raise NotImplementedError("Usuário financeiro não pode gerar relatórios.")
```

)

Essa estrutura de usuários por si só já é ruim, mas não vamos focar nisso agora. Vamos então montar uma classe para o programa dos nossos usuários!

#codly.new(

file: "programa.py",

```python
class Programa:
  def __init__(self, usuario: Usuario):
    self.usuario = usuario

  def gerar_relatorio(self):
    if isinstance(self.usuario, UsuarioComercial):
      self.usuario.gerar_relatorio()
```

)

Como eu disse anteriormente, o programa foi feito para atender a todos os usuários, mas ele só leva em conta o usuário comercial. Em primeira vista, podemos até pensar: "Ah, mas o usuário financeiro não precisa gerar relatórios, então tudo bem". No entanto, se criarmos uma nova classe de usuário, como `UsuarioMarketing` que precisa gerar relatórios, o programa vai quebrar, pois ele não vai saber lidar com esse novo tipo de usuário. Justamente aí que entra a violação do LSP, pois o usuário de marketing pode gerar relatórios, ele é uma subclasse de `Usuario`, então ele poderia e deveria entrar no programa sem o quebrar, mas o programa não foi feito para lidar com ele, então ele quebra. O LSP é violado.

Para consertar a violação do LSP *parcialmente*, vamos fazer uma simples alteração no programa para que ele aceite qualquer tipo de usuário:

#codly.new(

file: "programa.py",

```python
class Programa:
  def __init__(self, usuario: Usuario):
    self.usuario = usuario

  def gerar_relatorio(self):
    self.usuario.gerar_relatorio()
```

)

Agora nosso programa está idealmente correto, mas o LSP *ainda é violado*. Mas por quê? Perceba que no nosso arquivo `users.py`, a classe `UsuarioFinanceiro` *não implementa o método* `gerar_relatorio()`, então se passarmos um objeto dessa classe para o programa, ele vai quebrar. O LSP é violado porque a subclasse `UsuarioFinanceiro` não pode substituir a superclasse `Usuario` sem quebrar o programa. No entanto, o LSP está sendo violado em conjunto com outro pricípio do SOLID. Antes de implementarmos a devida correção, vamos falar sobre o outro princípio que está sendo violado.

== I - Princípio da Segregação de Interfaces
O Princípio da Segregação de Interfaces (Interface Segregation Principle - ISP) é outro princípio do SOLID que afirma que *nenhum cliente deve ser forçado a depender de métodos que não utiliza*. Em outras palavras, é melhor ter várias interfaces específicas do que uma interface única e genérica. O ISP incentiva a criação de interfaces menores e mais focadas, permitindo que os clientes implementem apenas os métodos que realmente precisam, evitando a implementação de métodos desnecessários.

Vamos rever o nosso arquivo `users.py` para entender como o ISP está sendo violado:

#codly.new(

file: "users.py",

```python
class Usuario(ABC):
  @abstractmethod
  def gerar_relatorio(self):
    ...

class UsuarioComercial(Usuario):
  def gerar_relatorio(self):
    print("Gerando relatório comercial...")

class UsuarioFinanceiro(Usuario):
  def gerar_relatorio(self):
    raise NotImplementedError("Usuário financeiro não pode gerar relatórios.")
```

)

Nós haviamos dito anteriormente que *todos* os usuários deveriam ter acesso ao nosso programa! Para isso, precisamos que todos eles possam gerar relatório, entretanto, nosso usuário financeiro não pode gerar relatórios. *Vamos supor* que em nosso cenário, isso foi erro de modelagem do programa, e usuários financeiros *realmente não podem gerar relatórios*. O ISP está sendo violado pois, mesmo que o usuário financeiro não precise gerar relatórios, ele é forçado a implementar o método `gerar_relatorio()`, mesmo que não faça sentido para ele.  Para corrigir isso, vamos criar uma nova interface chamada `UsuarioComRelatorio`, e o método de geração de relatórios vai ser movido para essa nova interface. Assim, apenas os usuários que realmente precisam gerar relatórios vão implementar esse método.

#codly.new(

file: "users.py",

```python
class Usuario(ABC):
  pass

class UsuarioComRelatorio(Usuario):
  @abstractmethod
  def gerar_relatorio(self):
    ...

class UsuarioComercial(UsuarioComRelatorio):
  def gerar_relatorio(self):
    print("Gerando relatório comercial...")

class UsuarioFinanceiro(Usuario):
  pass
```

)

Então mudamos a abordagem do nosso programa, em vez de ele ficar disponível para *qualquer usuário*, ele vai ficar disponível apenas para *usuários que podem gerar relatórios*.

#codly.new(

file: "programa.py",

```python
class Programa:
  def __init__(self, usuario: UsuarioComRelatorio):
    self.usuario = usuario

  def gerar_relatorio(self):
    self.usuario.gerar_relatorio()
```

)

Dessa forma, o LSP e o ISP foram corrigidos, e nosso programa agora está idealmente correto. O LSP foi corrigido pois agora qualquer subclasse de `UsuarioComRelatorio` pode substituir a superclasse sem quebrar o programa, e o ISP foi corrigido pois agora apenas os usuários que realmente precisam gerar relatórios implementam o método `gerar_relatorio()`, evitando a implementação de métodos desnecessários.

#pagebreak()

#align(center+horizon)[
  = Chain of Responsibilities Pattern
]

#pagebreak()

== O Problema
Imagine que estamos fazendo um programa de gestão de pedidos de uma empresa. Nós temos o pedido do nosso cliente, no entanto, algumas decisões de negócio nos foram informadas. Precisamos que, antes de enviar o pedido ao sistema, alguns pré-processamentos e verificações devem ser feitos. O nosso chefe disse que devemos implementar uma verificação de que as *informações do cliente estão no pedido* e que o usuário tem permissões para realizar aquele pedido.

Após algumas indagações, faz sentido implementar essas verificações sequencialmente e, se alguma falhar, nem continua!

#figure(
  image("images/A2/system-diagram-1.png"),
  caption: [Diagrama do sistema com as verificações de negócio implementadas sequencialmente]
)

Vamos criar essa estrutura então!

#codly.new(

```python
@dataclass
class Pedido:
  cliente: Cliente
  itens: list[Item]
  valor_total: float

class SistemaDePedidos():
  def verificar_informacoes_cliente(self, cliente: Cliente) -> bool:
    # Lógica para verificar informações do cliente
    ...
  
  def verificar_permissoes_usuario(self, usuario: Usuario) -> bool:
    # Lógica para verificar permissões do usuário
    ...

  def processar_pedido(self, pedido: Pedido):
    if not self.verificar_informacoes_cliente(pedido.cliente):
      raise ValueError("Informações do cliente inválidas.")
    if not self.verificar_permissoes_usuario(pedido.cliente.usuario):
      raise ValueError("Usuário não tem permissões para realizar o pedido.")
    ...
```

)

Caraca, que código lindo... Agora vamos imaginar a seguinte situação: Imagine que, conversando com seu colega de trabalho, ele fala que faz sentido adicionar uma verificação para que o pedido não ultrapasse o limite de crédito do cliente. Porém, também faz sentido adicionar uma checagem de segurança contra brute force attacks... O que você acha que deveríamos fazer dentro dessa classe que criamos para adicionar esses pontos que nosso colega de trabalho citou? Exatamente, *modificar* a classe `SistemaDePedidos`.

Pelo que já vimos desde os conceitos iniciais do SOLID, essa classe de sistema de pedidos tá uma *porcaria*. Primeiro que ela viola o _S_ ao colocar a responsabilidade de fazer as verificações no `SistemaDePedidos` e ela viola o _O_ ao fazer que, se eu quiser adicionar uma nova verificação, eu vou ter que modificar a classe `SistemaDePedidos`. Então o que cacete vamos fazer pra corrigir isso? É aí que entra o Chain of Responsibilities Pattern.

== A Solução
O design define que *cada checagem* deve ser feita de forma *independente* por uma *classe separada* chamada *handler*, de forma que existe uma função própria que, ao ser chamada, faz a checagem e, caso ela passe, chama o próximo handler da cadeia. Caso a checagem falhe, o handler lança uma exceção e a cadeia é interrompida. Dessa forma, cada handler é responsável por uma única checagem e a responsabilidade de chamar o próximo handler é delegada para o próprio handler, além de que, se um falha, a cadeia é interrompida e o pedido não é processado.

#figure(
  image("images/A2/chain-of-responsibility.png", width: 100%),
  caption: [Diagrama do sistema com as verificações de negócio implementadas em handlers independentes]
)

Vamos então corrigir aquele código feio que fizemos anteriormente e implementar o Chain of Responsibilities Pattern.

#codly.new(

file: "pedido.py",

```python
@dataclass
class Pedido:
  cliente: Cliente
  itens: list[Item]
  valor_total: float
```

)

#codly.new(

file: "handlers.py",

```python
class Handler(ABC):
  def __init__(self):
    self._proximo_handler = None
  
  def set_proximo(self, handler: "Handler"):
    self._proximo_handler = handler
    return handler  # Permite fazer encadeamento de chamadas

  @abstractmethod
  def verificar(self, pedido: Pedido):
    pass


class InformacaoClienteHandler(Handler):
  def verificar(self, pedido: Pedido):
    if not condition:  # Substitua "condition" pela lógica de checagem real
      raise ValueError("Informações do cliente inválidas.")
    if self._proximo_handler:
      self._proximo_handler.verificar(pedido)


class PermissaoUsuarioHandler(Handler):
  def verificar(self, pedido: Pedido):
    if not condition:  # Substitua "condition" pela lógica de checagem real
      raise ValueError("Permissão de usuário inválida.")
    if self._proximo_handler:
      self._proximo_handler.verificar(pedido)


class LimiteCreditoHandler(Handler):
  def verificar(self, pedido: Pedido):
    if not condition:  # Substitua "condition" pela lógica de checagem real
      raise ValueError("Limite de crédito insuficiente.")
    if self._proximo_handler:
      self._proximo_handler.verificar(pedido)


class BruteForceHandler(Handler):
  def verificar(self, pedido: Pedido):
    if not condition:  # Substitua "condition" pela lógica de checagem real
      raise ValueError("Possível ataque de força bruta detectado.")
    if self._proximo_handler:
      self._proximo_handler.verificar(pedido)
```

)

Com essa nova estrutura, mantemos todos os princípios do SOLID, pois cada handler é responsável por uma única checagem e, para criar uma nova verificação, basta criar um novo handler e adicioná-lo à cadeia, sem precisar modificar nenhuma das classes existentes. Vamos ver como ficaria a lógica de negócio do nosso sistema de pedidos com essa nova estrutura.

#codly.new(

file: "main.py",

```python
pedido = Pedido(cliente=cliente, itens=itens, valor_total=valor_total)

# Configurar a cadeia de responsabilidade
informacao_cliente_handler = InformacaoClienteHandler()
permissao_usuario_handler = PermissaoUsuarioHandler()
limite_credito_handler = LimiteCreditoHandler()
brute_force_handler = BruteForceHandler()

informacao_cliente_handler.set_proximo(permissao_usuario_handler)\
  .set_proximo(limite_credito_handler)\
  .set_proximo(brute_force_handler)

informacao_cliente_handler.verificar(pedido)  # Inicia a cadeia de verificações

sistema_de_pedidos.processar_pedido(pedido)  # Processa o pedido se todas as verificações passarem
```

)

Dá até uma sensação de alívio ver que agora o código está mais organizado e fácil de manter.

== A Variante
É interessante notar que o Chain of Responsibilities Pattern pode ser implementado de diferentes formas. Uma variante interessante é uma que troca a forma como a cadeia se comporta. Anteriormente, vimos que *cada handler* faz sua checagem e, caso ela passe, chama o próximo handler da cadeia. No entanto, existe uma outra abordagem em que o handler olha e diz: _"Eu posso processar? Se sim, vou processar e a cadeia *vai terminar*, se não, eu vou ver se o próximo handler consegue"_.

Pra manter a simplicidade do documento, vamos imaginar o seguinte cenário e tentar implementá-lo com essa variante do Chain of Responsibilities Pattern. Imagine que temos um sistema de atendimento de reclamações de usuários, nós temos uma classe `Reclamacao` que representa as informações que um usuário trouxe sobre seu problema. Na nossa empresa, possuímos o seguinte processo de atendimento: _Se a reclamação for simples, o atendente automático vai resolver, se for um pouco mais complexa, o atendente humano vai resolver, e se for muito complexa, o gerente vai resolver_. Então vamos implementar essa lógica com a variante do Chain of Responsibilities Pattern.

#codly.new(

file: "reclamacao.py",

```python
@dataclass
class Problema:
  descricao: str
  complexidade: int  # 1 = simples, 2 = média, 3 = complexa


class Handler(ABC):
  def __init__(self):
    self._parent_handler = None
  
  def set_parent(self, handler: "Handler"):
    self._parent_handler = handler
    return handler  # Permite fazer encadeamento de chamadas
  
  @abstractmethod
  def pode_processar(self, problema: Problema) -> bool:
    pass

  @abstractmethod
  def processar(self, problema: Problema):
    pass


class AtendenteAutomaticoHandler(Handler):
  def pode_processar(self, problema: Problema) -> bool:
    return problema.complexidade == 1

  def processar(self, problema: Problema):
    if not self.pode_processar(problema) and self._parent_handler:
      self._parent_handler.processar(problema)
      return
    print("Atendente automático resolveu o problema.")


class AtendenteHumanoHandler(Handler):
  def pode_processar(self, problema: Problema) -> bool:
    return problema.complexidade == 2
  
  def processar(self, problema: Problema):
    if not self.pode_processar(problema) and self._parent_handler:
      self._parent_handler.processar(problema)
      return
    print("Atendente humano resolveu o problema.")


class GerenteHandler(Handler):
  def pode_processar(self, problema: Problema) -> bool:
    return problema.complexidade == 3
  
  def processar(self, problema: Problema):
    if not self.pode_processar(problema) and self._parent_handler:
      self._parent_handler.processar(problema)
      return
    print("Gerente resolveu o problema.")
```

)

Nessa lógica, cada um dos handlers verifica se consegue processar o problema. Caso consiga, ele processa e a cadeia termina. Caso não consiga, ele passa para o próximo handler da cadeia.

#pagebreak()

#align(center+horizon)[
  = Strategy Pattern
]

#pagebreak()


#pagebreak()

#align(center+horizon)[
  = Command Pattern
]

#pagebreak()


#pagebreak()

#align(center+horizon)[
  = State Pattern
]

#pagebreak()
