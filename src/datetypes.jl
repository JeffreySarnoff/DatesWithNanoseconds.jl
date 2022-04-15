
(!(@isdefined Dates) && (using Dates)) # simplify development
(!(@isdefined TimeDates) && (import TimeDates: TimeDate, periods))
td = TimeDate("2019-10-14T12:16:25.223345987")
date, time = td.date, td.time;
dt = DateTime(date, floor(time, Millisecond));


# parts(Date) = (Year, Month, Day) ..
for (T, P) in zip(AvailableTypeSyms, AvailableParts)
    @eval parts(::Type{$T}) = $P
end

# parts(Date(2022, 11, 5)) == (Year(2022), Month(11), Day(5)) ..
for (T, P) in zip(AvailableTypeSyms, AvailableParts)
    @eval parts(x::$T) = map(p -> p(x), $P)
end

# CompoundPeriod(Date(2022, 11, 5) == Year(2022) + Month(11) + Day(5)
for T in AvailableTypeSyms
    @eval Dates.CompoundPeriod(x::$T) = sum(parts(x))
end

# CompoundPeriod --> Date | Time | DateTime | TimeDate

function Date(x::Dates.CompoundPeriod)
    n = length(x.periods)
    (n == 0) && ArgumentError("`x` cannot be empty")
    c = canonicalize(x)
    !(isa(c.periods[1], Year)) && ArgumentError("`x` is missing a `Year`")

    date = Date(c.periods[1]) # first day of Year(x)
    if n > 1 && (isa(c.periods[2], Month) || isa(c.periods[2], Day) || isa(c.periods[2], Week))
        date += c.periods[2]
        if n > 2 && (isa(c.periods[3], Day) || isa(c.periods[3], Week))
            date += c.periods[3]
            if n > 3 && isa(c.periods[4], Day)
                date += c.periods[3]
            end
        end
    end
    date
end

function Time(x::Dates.CompoundPeriod)
    i, n = 1, length(x.periods)
    (n == 0) && ArgumentError("`x` cannot be empty")
    c = canonicalize(x)

    for p in c.periods
        if p in (Year, Quarter, Month, Week, Day)
            i += 1
            continue
        end
    end
    if i === 0
        Time0
    else
        Time(c.periods[i:end]...)
    end
end

function DateTime(x::Dates.CompoundPeriod)
    n = length(x.periods)
    (n == 0) && ArgumentError("`x` cannot be empty")
    c = canonicalize(x)
    !(isa(c.periods[1], Year)) && ArgumentError("`x` is missing a `Year`")

    dt = zeros(Int, length(DateTimeParts))
    for p in c.periods
        (isa(p, Microsecond) || isa(p, Nanosecond)) && continue
        idx, val = datetime_field(p)
        dt[idx] += val
    end
    DateTime(dt...)
end

function TimeDate(x::Dates.CompoundPeriod)
    n = length(x.periods)
    (n == 0) && ArgumentError("`x` cannot be empty")
    c = canonicalize(x)
    !(isa(c.periods[1], Year)) && ArgumentError("`x` is missing a `Year`")

    dt = zeros(Int, length(TimeDateParts))
    for p in c.periods
        idx, val = datetime_field(p)
        dt[idx] += val
    end
    DateTime(dt...)
end

# Date | Time | DateTime | TimeDate  -->  CompoundPeriod

Dates.CompoundPeriod(x::Date) = sum(map((fn, a) -> fn(a), DateParts, periods(x)))
Dates.CompoundPeriod(x::Time) = sum(map((fn, a) -> fn(a), TimeParts, periods(x)))
Dates.CompoundPeriod(x::DateTime) = sum(map((fn, a) -> fn(a), DateTimeParts, periods(x)))
Dates.CompoundPeriod(x::TimeDate) = sum(map((fn, a) -> fn(a), TimeDateParts, periods(x)))
