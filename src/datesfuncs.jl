for F in (:dayabbr, :dayname, :dayofmonth, :dayofquarter,
    :dayofweek, :dayofweekofmonth, :dayofyear, :daysinmonth,
    :daysinyear, :daysofweekinmonth, :isleapyear, :monthabbr,
    :monthday, :monthname, :quarterofyear, :yearmonthday)
    @eval Dates.$F(td::TimeDate) = $F(td.date)
end

for F in (:firstdayofmonth, :firstdayofquarter,
    :firstdayofweek, :firstdayofyear, :lastdayofmonth,
    :lastdayofquarter, :lastdayofweek, :lastdayofyear)
    @eval Dates.$F(td::TimeDate) = TimeDate(Time0, $F(td.date))
end

# tofirst, tolast, toprev, tonext just work with TimeDate

timedate2rata(x::TimeDate) = datetime2rata(DateTime(x))
rata2timedate(x::Int64) = TimeDate(rata2datetime(x))

# extend these unexported functions

Dates.days(x::TimeDate) = days(x.date)
Dates.days(x::Microsecond) = div(value(x), MicrosecondsPerDay)
Dates.days(x::Nanosecond) = div(value(x), NanosecondsPerDay)

Dates.value(x::TimeDate) =
    Int128(NanosecondsPerDay) * Dates.value(x.date) + Dates.value(x.time)

# define these missing functions
daysinquarter(x::T) where {T<:Union{Date,DateTime,TimeDate}} =
    (lastdayofquarter(x)-firstdayofquarter(x)).periods[1].value + 1

tomillis(x::Nanosecond)  = div(x, 1_000_000)
tomillis(x::Microsecond) = div(x, 1_000)
tomillis(x::Year) = daysinyear(year(x))

for T in (:Year, :Month)
    @eval tomillis(x::$T) = Dates.days(x) * MillisecondsPerDay
end

for T in DateTimeParts[3:end-1]
    @eval tomillis(x::$T) = Dates.toms(x)
end
for T in (:Microseconds, :Nanoseconds)
    @eval tomillis(x::$T) = Dates.tons(x)
end
