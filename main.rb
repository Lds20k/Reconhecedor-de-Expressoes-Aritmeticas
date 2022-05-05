require 'raabro'

module Reconhecedor include Raabro
    def digito(i); rex(:digito, i, /[0-9]+/); end
    def simbolomenos(i); rex(nil, i, /\-/); end

    def menos(i); seq(:menos, i, :simbolomenos, :estrutura); end
        
    def parentesesStart(i); rex(nil, i, /\(/); end
    def parentesesEnd(i); rex(nil, i, /\)/); end
    def parenteses(i); seq(:parenteses, i, :parentesesStart, :operacao1, :parentesesEnd); end
    
    def estrutura(i); alt(:estrutura, i, :parenteses, :menos, :digito); end

    def rewrite_digito(t)
        "Número \t\t\t| Unária \t| " + t.string
    end

    def rewrite_menos(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append("Negativação \t\t| Unária \t| " + t.string)
    end

    def rewrite_parenteses(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append("Parenteses \t\t| Unária \t| " + t.string)
    end

    def rewrite_estrutura(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    # Operação 3

    def simbolopotencia(i); rex(nil, i, /\^/); end
    def seqoperacao3(i); seq(:seqoperacao3, i, :estrutura, :simbolopotencia, :estrutura); end
    def operacao3(i); alt(:operacao3, i, :seqoperacao3, :estrutura); end

    def rewrite_seqoperacao3(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append("Potencia \t\t| Binária \t| " + t.string)
    end

    def rewrite_operacao3(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    # Operação 2

    def simbolomultiplicacao(i); rex(nil, i, /\*/); end
    def simbolodivisao(i); rex(nil, i, /\//); end
    def simbolooperacao2(i); alt(:operacao2, i, :simbolomultiplicacao, :simbolodivisao); end
    def seqoperacao2(i); seq(:seqoperacao2, i, :operacao3, :simbolooperacao2, :operacao2); end
    def operacao2(i); alt(:operacao2, i, :seqoperacao2, :operacao3); end

    def rewrite_seqoperacao2(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append((folhas[1].string == "*" ? "Multiplicação" : "Divisão\t") + "\t\t| Binária \t| " + t.string)
    end

    def rewrite_operacao2(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    # Operação 1

    def simbolosoma(i); rex(nil, i, /\+/); end
    def simbolodiferenca(i); rex(nil, i, /\-/); end
    def simbolooperacao1(i); alt(:operacao1, i, :simbolosoma, :simbolodiferenca); end
    def seqoperacao1(i); seq(:seqoperacao1, i, :operacao2, :simbolooperacao1, :operacao1); end
    def operacao1(i); alt(:operacao1, i, :seqoperacao1, :operacao2); end

    def rewrite_seqoperacao1(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append((folhas[1].string == "+" ? "Soma\t": "Diferença") + "\t\t| Binária \t| " + t.string)
    end

    def rewrite_operacao1(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    def rewrite_operacao1(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end
end

def is_array (a)
    return a.is_a?(Array)
end

def custom_map(list)
    temp = []
    for i in list
        if not is_array(i)
            temp.append(i)
        else 
            temp += custom_map(i) 
        end
    end
    return temp
end
condicao_continuar = true

while condicao_continuar
    system("clear") || system("cls")
    puts "Digite uma expressão:"
    entrada = gets().chomp().strip()
    system("clear") || system("cls")
    reconhecido = Reconhecedor.parse(entrada.delete(' '))

    if reconhecido != nil
        reconhecido = custom_map(reconhecido).compact

        puts "Entrada: " + entrada
        puts

        puts "---------------------------------------------------"
        puts "Nome \t\t\t| Tipo \t\t| Valor"
        puts "---------------------------------------------------"
        puts reconhecido
        puts "---------------------------------------------------"
    else
        puts "Não reconhecido!"
    end

    puts "Se deseja sair digite 'S' senão pressione enter:"
    parar = gets().chomp().strip().upcase()
    if parar[0] == 'S'
        condicao_continuar = false
    end
end