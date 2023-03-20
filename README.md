# PSRProgressBar.jl

<div align="center">
    <a href="/assets/">
        <img src="/assets/logo.svg" width=400px alt="PSRProgressBar.jl" />
    </a>
</div>

## Getting Started

### Installation
```julia
julia> ]add https://github.com/psrenergy/PSRProgressBar.jl#master
```

### Example

```julia
using PSRProgressBar

pb = PSRProgressBar.ProgressBar(maximum_steps = 100, tick = "+", left_bar = "|", right_bar="|")

for i in 1:100
    PSRProgressBar.next!(pb)
    sleep(0.1)
end
```