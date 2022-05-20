require 'raabro'
require 'json'

module Reconhecedor include Raabro
    def digito(i); rex(:digito, i, /[0-9]+/); end
    def simbolomenos(i); rex(nil, i, /\-/); end

    def menos(i); seq(:menos, i, :simbolomenos, :estrutura); end
        
    def parentesesStart(i); rex(nil, i, /\(/); end
    def parentesesEnd(i); rex(nil, i, /\)/); end
    def parenteses(i); seq(:parenteses, i, :parentesesStart, :operacao1, :parentesesEnd); end
    
    def estrutura(i); alt(:estrutura, i, :parenteses, :menos, :digito); end

    def rewrite_digito(t)
        t.string
    end

    def rewrite_menos(t)
        t.string
    end

    def rewrite_parenteses(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    def rewrite_estrutura(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    # Operação 3

    def simbolopotencia(i); rex(:simbolopotencia, i, /\^/); end
    def operacao3segundaparte(i); seq(:operacao3segundaparte, i, :simbolopotencia, :operacao3); end
    def seqoperacao3(i); seq(:seqoperacao3, i, :estrutura, :operacao3segundaparte, "+"); end
    def operacao3(i); alt(:operacao3, i, :seqoperacao3, :estrutura); end

    def rewrite_simbolopotencia(t)
        'potencia'
    end

    def rewrite_operacao3segundaparte(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append "]"
    end

    def rewrite_seqoperacao3(t)
        folhas = t.children
        retorno = folhas.collect { |e| rewrite(e)}
        for i in 1..folhas.length - 1 
            retorno.unshift "["
        end
        retorno
    end

    def rewrite_operacao3(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    # Operação 2

    def simbolomultiplicacao(i); rex(:simbolomultiplicacao, i, /\*/); end
    def simbolodivisao(i); rex(:simbolodivisao, i, /\//); end
    def simbolooperacao2(i); alt(:operacao2, i, :simbolomultiplicacao, :simbolodivisao); end
    def operacao2segundaparte(i); seq(:operacao2segundaparte, i, :simbolooperacao2, :operacao3); end
    def seqoperacao2(i); seq(:seqoperacao2, i, :operacao3, :operacao2segundaparte, "+"); end
    def operacao2(i); alt(:operacao2, i, :seqoperacao2, :operacao3); end

    def rewrite_simbolomultiplicacao(t)
        'multiplicacao'
    end

    def rewrite_simbolodivisao(t)
        'divisao'
    end

    def rewrite_operacao2segundaparte(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append "]"
    end

    def rewrite_seqoperacao2(t)
        folhas = t.children
        retorno = folhas.collect { |e| rewrite(e)}
        for i in 1..folhas.length - 1 
            retorno.unshift "["
        end
        retorno
    end

    def rewrite_operacao2(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    # Operação 1

    def simbolosoma(i); rex(:simbolosoma, i, /\+/); end
    def simbolodiferenca(i); rex(:simbolodiferenca, i, /\-/); end
    def simbolooperacao1(i); alt(:operacao1, i, :simbolosoma, :simbolodiferenca); end
    def operacao1segundaparte(i); seq(:operacao1segundaparte, i, :simbolooperacao1, :operacao2); end
    def seqoperacao1(i); seq(:seqoperacao1, i, :operacao2, :operacao1segundaparte, "+"); end
    def operacao1(i); alt(:operacao1, i, :seqoperacao1, :operacao2); end

    def rewrite_simbolosoma(t)
        'soma'
    end

    def rewrite_simbolodiferenca(t)
        'diferenca'
    end

    def rewrite_operacao1segundaparte(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append "]"
    end

    def rewrite_seqoperacao1(t)
        folhas = t.children
        retorno = folhas.collect { |e| rewrite(e)}
        for i in 1..folhas.length - 1 
            retorno.unshift "["
        end
        retorno
    end

    def rewrite_operacao1(t)
        folhas = t.children
        retorno = folhas.collect { |e| rewrite(e)}
        #puts JSON.dump retorno
        retorno
    end
end

def is_array (a)
    return a.is_a?(Array)
end

def remover_nil(lista)
    temp = []
    for i in lista
        if not is_array(i)
            temp.append(i)
        else 
            temp += remover_nil(i) 
        end
    end
    return temp
end

def cascata(lista, temp = [])
    aux = temp
    while not lista.empty?
        if lista[0].match(/\[/)
            lista.delete_at(0) #INICIO [
            aux.append(cascata(lista))
            lista.delete_at(0) #FINAL ]
        elsif lista[0].match(/soma|diferenca|multiplicacao|divisao|potencia/)
            aux.append(lista.delete_at(0)) #SOMA|DIFERENCA|MULTIPLICACAO|DIVISAO|POTENCIA
            if lista[0].match(/[0-9]+/)
                aux.append(lista.delete_at(0)) #NUMERO
                return aux
            end
        elsif not lista[0].match(/\]/)
            aux.append(lista.delete_at(0)) #NUMERO
            aux.append(lista.delete_at(0)) #OPERACAO
            if lista[0].match(/[0-9]+/)
                aux.append(lista.delete_at(0)) #NUMERO
                return aux
            end
        else
            return aux
        end
    end
    return temp[0]
end

def ordenar(lista)
    lista.insert(0, '"' + lista.delete_at(1) + '"')
    lista.insert(1, ', ')
    if is_array(lista[2])
        ordenar(lista[2])
    end
    lista.insert(3, ', ')
    if is_array(lista[4])
        ordenar(lista[4])
    end

    lista.insert(0, '[')
    lista.insert(-1, ']')
end

condicao_continuar = true
while condicao_continuar
    system("clear") || system("cls")
    puts "Digite uma expressão:"
    entrada = gets().chomp().strip()

    if entrada != ''
        system("clear") || system("cls")
        reconhecido = Reconhecedor.parse(entrada.delete(' '))
    end
    if reconhecido != nil
        reconhecido_p = remover_nil(reconhecido).compact
        reconhecido_p = cascata(reconhecido_p)
        ordenar(reconhecido_p)

        puts "Entrada: " + entrada
        puts

        puts reconhecido_p.join()
    else
        puts "Não reconhecido!"
    end

    puts "Se deseja sair digite 'S' senão pressione enter:"
    parar = gets().chomp().strip().upcase()
    if parar[0] == 'S'
        condicao_continuar = false
    else
        reconhecido = nil 
    end
end