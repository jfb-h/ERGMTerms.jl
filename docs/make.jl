using ERGMTerms
using Documenter

DocMeta.setdocmeta!(ERGMTerms, :DocTestSetup, :(using ERGMTerms); recursive=true)

makedocs(;
    modules=[ERGMTerms],
    authors="Jakob Hoffmann <jfb-hoffmann@hotmail.de> and contributors",
    sitename="ERGMTerms.jl",
    format=Documenter.HTML(;
        canonical="https://jfb-h.github.io/ERGMTerms.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jfb-h/ERGMTerms.jl",
    devbranch="main",
)
