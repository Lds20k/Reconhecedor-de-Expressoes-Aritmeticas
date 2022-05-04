# Reconhecedor de Expressões Aritméticas

O objetivo deste EP é um fazer um reconhecer sintático (parser) de expressões matemáticas simples, com as operações básicas.

Operações para ser reconhecidas:

[Operações](https://www.notion.so/2c63f42061bd42dc8a57266205192f86)

## Parte 1 - Entrega da Gramática (3.0)

O EP deve implementar um autômato de pilha determinístico que reconheça expressões matemáticas com as operações citadas acima.

Para isso, deve-se desenvolver uma gramática livre de contexto que gera expressões matemáticas.

Ponto de atenção com a Gramática:

- Seguir a regra de precedência de operações
- Seguir a regra de associatividade (ou a direita ou a à esquerda)
- Não há limite para o tamanho do número

Deve-se entregar as regras da gramática e um documento  no Blackboard. Fazer a árvore com a expansão da seguinte expressão:

9^(1 * -2 + 3) - 3 / ( 6 + 3 )

## Parte 2 - Reconhecedor (6.0)

NÃO É PRECISO RESOLVER A EXPRESSÃO. Só necessário verificar se ela é válida. A resolução é assunto da disciplina de Compiladores.

Deve-se usar a biblioteca: 

[https://github.com/floraison/raabro](https://github.com/floraison/raabro)

O reconhecedor deve emitir as seguintes avisos quando fizer uma reconhecimento conforme tabela abaixo:

[Operações](https://www.notion.so/7f0d114263bf41a091d9c4c98fc54a56)

Assim, 4+5*2 deve emitir:

["soma", [ "multiplicacao", 5, 2], 4]

Exemplos de expressões válidas (deve mostrar que foi aceita):

(1 + 4) * 2^4

7 / ( 1 - 3 )

9^(1 * 6 / 2 + 4)

2 + 4 ^ -4 / 4

Exemplos de expressões inválidas (deve mostrar que não foi aceita):

^ 2 + 4

9 * 2 +

9 + + 3

( ) * 3

( 3 + 3

### Apresentação (1.0)

[O que é e não é avaliado em vídeos](https://www.notion.so/O-que-e-n-o-avaliado-em-v-deos-03c79668b22a4162b8f91d6e2b458103)

Este trabalho deve seguir:

[Código de ética - Política Antiassédio](https://www.notion.so/C-digo-de-tica-Pol-tica-Antiass-dio-81b47fc97f7d40a3ad1d6d882f3e1a65)

[Política antiplágio](https://www.notion.so/Pol-tica-antipl-gio-5187d7b1ab514bfb8424ac0fcfb59dba)