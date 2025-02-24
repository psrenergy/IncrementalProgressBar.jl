using Test
using Aqua

import IncrementalProgressBar: IncrementalProgressBar

function test_aqua()
    Aqua.test_all(IncrementalProgressBar)
    return nothing
end

function test_progressbar()
    pb = IncrementalProgressBar.ProgressBar(maximum_steps = 10)
    for i = 1:10
        redirect_stdout(devnull) do
            IncrementalProgressBar.next!(pb, 1)
        end
        @test pb.current_steps == i
    end

    pb = IncrementalProgressBar.ProgressBar(
        maximum_steps = 10,
        display = IncrementalProgressBar.INCREMENTAL,
    )
    for i = 1:10
        redirect_stdout(devnull) do
            IncrementalProgressBar.next!(pb, 1)
        end
        @test pb.current_steps == i
    end

    pb = IncrementalProgressBar.ProgressBar(
        maximum_steps = 1,
        maximum_length = 50,
        display = IncrementalProgressBar.INCREMENTAL,
        has_elapsed_time = false,
    )
    open("stodout.txt", "w+") do io
        redirect_stdout(io) do
            IncrementalProgressBar.next!(pb, 1)
        end
    end
    str = read("stodout.txt", String)
    rm("stodout.txt")
    @test string(str[end]) == pb.right_bar
end

function test_length()
    last_stage = 3
    first_stage = 1

    p_incremental = IncrementalProgressBar.ProgressBar(
        maximum_steps = last_stage - first_stage + 1,
        maximum_length = 72,
        display = IncrementalProgressBar.INCREMENTAL,
        color = :green,
    )
    p_iterative = IncrementalProgressBar.ProgressBar(
        maximum_steps = last_stage - first_stage + 1,
        maximum_length = 72,
        display = IncrementalProgressBar.ITERATIVE,
        color = :green,
    )

    for stage = first_stage:last_stage
        redirect_stdout(devnull) do
            IncrementalProgressBar.next!(p_incremental)
            IncrementalProgressBar.next!(p_iterative)
        end
    end
    @test p_incremental.current_ticks == p_iterative.current_ticks
    @test p_incremental.current_ticks == p_incremental.maximum_length - 2

    last_stage = 104
    first_stage = 1

    p_incremental = IncrementalProgressBar.ProgressBar(
        maximum_steps = last_stage - first_stage + 1,
        maximum_length = 72,
        display = IncrementalProgressBar.INCREMENTAL,
        color = :green,
    )
    p_iterative = IncrementalProgressBar.ProgressBar(
        maximum_steps = last_stage - first_stage + 1,
        maximum_length = 72,
        display = IncrementalProgressBar.ITERATIVE,
        color = :green,
    )

    for stage = first_stage:last_stage
        redirect_stdout(devnull) do
            IncrementalProgressBar.next!(p_incremental)
            IncrementalProgressBar.next!(p_iterative)
        end
    end
    @test p_incremental.current_ticks == p_iterative.current_ticks
    @test p_incremental.current_ticks == p_incremental.maximum_length - 2
end

function test_convert_time()
    @test IncrementalProgressBar._convert_time_unit(0.1) == "100ms"
    @test IncrementalProgressBar._convert_time_unit(7200.0) == "2h"
    @test IncrementalProgressBar._convert_time_unit(180.0) == "3min"
    @test IncrementalProgressBar._convert_time_unit(10.0) == "10s"
end

test_aqua()
test_progressbar()
test_length()
test_convert_time()
