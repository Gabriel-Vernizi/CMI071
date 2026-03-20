using LaTeXStrings

function Switch(; default::Bool=false)
    checked_str = default ? "checked" : ""
    
    return HTML("""
    <label class="custom-switch">
        <input type="checkbox" $(checked_str)>
        <span class="slider"></span>
        
        <style>
            .custom-switch { position: relative; display: inline-block; width: 44px; height: 24px; margin-right: 8px; vertical-align: middle; }
            .custom-switch input { opacity: 0; width: 0; height: 0; }
            .custom-switch .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: .3s; border-radius: 24px; }
            .custom-switch .slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px; background-color: white; transition: .3s; border-radius: 50%; }
            .custom-switch input:checked + .slider { background-color: #4CAF50; }
            .custom-switch input:checked + .slider:before { transform: translateX(20px); }
        </style>

        <script>
            const label = currentScript.parentElement;
            const input = label.querySelector("input");
            
            // Define o valor oficial desse elemento para o Pluto como true/false
            Object.defineProperty(label, "value", {
                get: () => input.checked,
                set: (val) => { input.checked = val; }
            });
            
            // Dispara um evento para o Pluto atualizar a variável toda vez que clicar
            input.onchange = (e) => {
                e.stopPropagation();
                label.dispatchEvent(new CustomEvent("input"));
            };
        </script>
    </label>
    """)
end

# ---------------- #

function plot_SF(Xs, f, a_n, b_n, N; show_f=true, title=L"Comparação entre $f(x)$ e $SF(x)$", plt=nothing)

    if isnothing(plt)
        plt = plot(title=title)
        
        if show_f
            plot!(plt, Xs, f.(Xs), label=L"$f(x)$", lc=:black, lw=2)
        end
    end

    SF(x, N) = sum(a_n(i)*cos(i*x) + b_n(i)*sin(i*x) for i in 1:N) + a_n(0)/2

    plot!(plt, Xs, SF.(Xs, N), label=L"$SF_{%$(N)}(x)$", ls=:dot)
    
    return plt
end

# ---------------- #

function plot_SF_examples(Xs,f,a_n,b_n,N_examples,show_f=true, title=L"Exemplos de comparação entre $f(x)$ e $SF(x)$", plt=nothing)
    if isnothing(plt)
        plt = plot(title=title)
        
        if show_f
            plot!(plt, Xs, f.(Xs), label=L"$f(x)$", lc=:black, lw=2)
        end
    end

    SF(x, N) = sum(a_n(i)*cos(i*x) + b_n(i)*sin(i*x) for i in 1:N) + a_n(0)/2

    for i in N_examples
        plot!(plt, Xs, SF.(Xs,i), label=L"$SF_{%$i}(x)$", ls=:dot,legendfontsize=6)
    end
    return plt
end

# ---------------- #

function stem_plot_fourier_coefficients(a_n,b_n,N,SF_text_approx,color;plt=nothing,markersize=5,SF_label="temp")
    if isnothing(plt)
        plt = plot(title=L"Decaimento dos Coeficientes de Fourier para $SF(x) \approx %$(SF_text_approx) $")
    end

    c_n(k) = sqrt(a_n(k)^2 + b_n(k)^2)
    I = 1:N

    plot!(plt, I, c_n.(I), st=:sticks, label=SF_label, lw=2,color=color)
    scatter!(plt,I,c_n.(I),label="",color=color,ms=markersize)

    return plt
end

# ---------------- #

function Erro_SF(Xs,f,a_n,b_n,N)
    SF(x, N) = sum(a_n(i)*cos(i*x) + b_n(i)*sin(i*x) for i in 1:N) + a_n(0)/2 
    return abs.(f.(Xs) - SF.(Xs,N))
end