export Clock, TICK, SLEEP_TIME
export tick, job!

mutable struct Clock <: System
  started::Base.Event
  stopped::Bool
  freq::AbstractFloat
  Clock() = new(Base.Event(), true, 0.01667)
end

struct TICK
  Δ::AbstractFloat # seconds, but has a distinct meaning from from RT_SEC
end

struct SLEEP_TIME
  Δ::UInt # time in nanoseconds to sleep for
end

function Base.sleep(s::SLEEP_TIME)
  t1 = time_ns()
  while true
    if time_ns() - t1 >= s.Δ break end
    yield()
  end
  return time_ns() - t1
end

function tick(Δ)
  δ = sleep(SLEEP_TIME(Δ * 1e9))
  sendMessage(TICK(δ / 1e9))
  @debug "tick"
end

function job!(c::Clock, f, arg=1)
  function job()
    Base.wait(c.started)
    while !c.stopped
      f(arg)
    end
  end
  schedule(Task(job))
end

function awake!(c::Clock)
  job!(c, tick, c.freq)

  c.stopped = false

  Base.notify(c.started)
end

function shutdown!(c::Clock)
  c.stopped = true
  c.started = Base.Event() # old one remains signaled no matter what, replace
end