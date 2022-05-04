require 'raabro'

module Reconhecedor include Raabro
    def digito(i); rex(:digito, i, /[0-9]+/); end
    def simbolomenos(i); rex(:simbolomenos, i, /\-/); end

    def menos(i); seq(:estrutura, i, :simbolomenos, :estrutura); end
        
    def parentesesStart(i); rex(nil, i, /\(/); end
    def parentesesEnd(i); rex(nil, i, /\)/); end
    def parenteses(i); seq(:parenteses, i, :parentesesStart, :operacao1, :parentesesEnd); end
    
    def estrutura(i); alt(:estrutura, i, :parenteses, :menos, :digito); end

    def rewrite_digito(t)
        "Número \t\t\t| Unária \t| " + t.string
    end

    def rewrite_simbolomenos(t)
        "Negativação \t\t| Unária \t| " + t.string
    end

    def rewrite_parenteses(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append("Parenteses \t\t| Unária \t|" + t.string)
    end

    def rewrite_estrutura(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    # Operação 1

    def simbolosoma(i); rex(nil, i, /\+/); end
    def simbolodiferenca(i); rex(nil, i, /\-/); end
    def simbolooperacao1(i); alt(:operacao1, i, :simbolosoma, :simbolodiferenca); end
    def seqoperacao1(i); seq(:seqoperacao1, i, :estrutura, :simbolooperacao1, :operacao3); end
    def operacao1(i); alt(:operacao1, i, :seqoperacao1, :estrutura); end

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

    # Operação 2

    def simbolomultiplicacao(i); rex(nil, i, /\*/); end
    def simbolodivisao(i); rex(nil, i, /\//); end
    def simbolooperacao2(i); alt(:operacao2, i, :simbolomultiplicacao, :simbolodivisao); end
    def seqoperacao2(i); seq(:seqoperacao2, i, :estrutura, :simbolooperacao2, :operacao3); end
    def operacao2(i); alt(:operacao2, i, :seqoperacao2, :operacao1); end

    def rewrite_seqoperacao2(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append((folhas[1].string == "*" ? "Multiplicação" : "Divisão\t") + "\t\t| Binária \t| " + t.string)
    end

    def rewrite_operacao2(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}
    end

    # Operação 3

    def simbolopotencia(i); rex(nil, i, /\^/); end
    def seqoperacao3(i); seq(:seqoperacao3, i, :estrutura, :simbolopotencia, :operacao3); end
    def operacao3(i); alt(:operacao3, i, :seqoperacao3, :operacao2); end

    def rewrite_seqoperacao3(t)
        folhas = t.children
        folhas.collect { |e| rewrite(e)}.append("Potencia \t\t| Binária \t| " + t.string)
    end

    def rewrite_operacao3(t)
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

entrada = "1 / 3 + 4"
reconhecido = Reconhecedor.parse(entrada.delete(' '))
reconhecido = custom_map(reconhecido).compact

puts "Entrada: " + entrada
puts

puts "---------------------------------------------------"
puts "Nome \t\t\t| Tipo \t\t| Valor"
puts "---------------------------------------------------"
puts reconhecido
puts "---------------------------------------------------"