function _convert_time_unit(time::Real)
    t_unit = if time < 1.0
        time = round(Int, time * 1000.0)
        "ms"
    elseif time > 3600.0
        time = round(Int, time / 3600.0)
        "h"
    elseif time > 60.0
        time = round(Int, time / 60.0)
        "min"
    else
        time = round(Int, time)
        "s"
    end
    return "$(time)$(t_unit)"
end

function _eta_text(p::AbstractProgressBar, new_length::Real)
    if !p.has_eta
        return ""
    end
    if !p.eta_started
        return " ETA: --"
    end

    s2 = p.maximum_steps - p.current_steps # remaining length
    t1 = time() - p.time # time to get from p.current_length to new_length

    eta = t1 * s2

    return " ETA: $(_convert_time_unit(eta))"
end

function _elapsed_text(p::AbstractProgressBar)
    if !p.has_elapsed_time
        return ""
    end
    elapsed = time() - p.start_time

    return " Time: $(_convert_time_unit(elapsed))"
end

function _percentage_text(p::AbstractProgressBar, frac::Real)
    if !p.has_percentage
        return ""
    end
    percentage = floor(Int, frac * 100)
    percentage_text = (" "^(4 - length("$percentage"))) * "$percentage" # percentage text should always have length 5 ( 1 for spacing + xxx%)
    if p.has_percentage && p.display == ITERATIVE
        return percentage_text * "%"
    end
    return " "^5
end
