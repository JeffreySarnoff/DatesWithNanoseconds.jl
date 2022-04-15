const HoursPerDay = Int64(24)
const MinutesPerHour = Int64(60)
const SecondsPerMinute = Int64(60)
const MillisecondsPerSecond = Int64(1_000)
const MicrosecondsPerMillisecond = Int64(1_000)
const NanosecondsPerMicrosecond = Int64(1_000)

const MinutesPerDay = HoursPerDay * MinutesPerHour

const SecondsPerHour = MinutesPerHour * SecondsPerMinute
const SecondsPerDay = HoursPerDay * SecondsPerHour

const MillisecondsPerMinute = SecondsPerMinute * MillisecondsPerSecond
const MillisecondsPerHour = MinutesPerHour * MillisecondsPerMinute
const MillisecondsPerDay = HoursPerDay * MillisecondsPerHour

const MicrosecondsPerSecond = MillisecondsPerSecond * MicrosecondsPerMillisecond
const MicrosecondsPerMinute = SecondsPerMinute * MillisecondsPerSecond
const MicrosecondsPerHour = MinutesPerHour * MillisecondsPerMinute
const MicrosecondsPerDay = HoursPerDay * MillisecondsPerHour

const NanosecondsPerMillisecond = MicrosecondsPerMillisecond * NanosecondsPerMicrosecond
const NanosecondsPerSecond = MillisecondsPerSecond * NanosecondsPerMillisecond
const NanosecondsPerMinute = SecondsPerMinute * NanosecondsPerSecond
const NanosecondsPerHour = MinutesPerHour * NanosecondsPerMinute
const NanosecondsPerDay = HoursPerDay * NanosecondsPerHour

const Time0 = Time(0)

const EPOCH_UNIX = DateTime(1970, 1, 1)
const RATA_UNIX = 719163                   # Rata Die on EPOCH_UNIX

# field related


const DateParts = (Year, Month, Day)
const TimeParts = (Hour, Minute, Second, Millisecond, Microsecond, Nanosecond)
const DateTimeParts = (Year, Month, Day, Hour, Minute, Second, Millisecond)
const TimeDateParts = (Year, Month, Day, Hour, Minute, Second, Millisecond, Microsecond, Nanosecond)

const AvailableTypes = (Date, Time, DateTime, TimeDate)
const AvailableParts = (DateParts, TimeParts, DateTimeParts, TimeDateParts)

const DatePartSyms = Symbol.(DateParts)
const TimePartSyms = Symbol.(TimeParts)
const DateTimePartSyms = Symbol.(DateTimeParts)
const TimeDatePartSyms = Symbol.(TimeDateParts)

const AvailableTypeSyms = Symbol.(AvailableTypes)
const AvailablePartSyms = map(x -> Symbol.(x), AvailableParts)

# positions of each period's field within constructor [and its value]

function period_field(::Type{T}, x) where {T}
    if T === Date
        date_field(x)
    elseif T === Time
        time_field(x)
    elseif T === TDateTime
        datetime_field(x)
    elseif T === TimeDate
        timedate_field(x)
    end
end

function date_field(x)
    if isa(x, Year)
        (1, x.value)
    elseif isa(x, Month)
        (2, x.value)
    elseif isa(x, Day)
        (3, x.value)
    elseif isa(x, Week)
        (3, 7 * x.value)
    elseif isa(x, Quarter)
        (2, 3 * x.value)
    end
end

function date_fieldindex(x)
    if isa(x, Year)
         1
    elseif isa(x, Month)
         2
    elseif isa(x, Day)
         3
    end
end

function time_field(x)
    if isa(x, Hour)
        (1, x.value)
    elseif isa(x, Minute)
        (2, x.value)
    elseif isa(x, Second)
        (3, x.value)
    elseif isa(x, Millisecond)
        (4, x.value)
    elseif isa(x, Microsecond)
        (5, x.value)
    else
        (6, x.value)
    end
end

function time_fieldindex(x)
    if isa(x, Hour)
        1
    elseif isa(x, Minute)
        2
    elseif isa(x, Second)
        3
    elseif isa(x, Millisecond)
        4,
    elseif isa(x, Microsecond)
        5
    elseif isa(x, Millisecond)
        6
    end
end

function datetime_field(x)
    if isa(x, Year)
        (1, x.value)
    elseif isa(x, Month)
        (2, x.value)
    elseif isa(x, Day)
        (3, x.value)
    elseif isa(x, Week)
        (3, 7 * x.value)
    elseif isa(x, Hour)
        (4, x.value)
    elseif isa(x, Minute)
        (5, x.value)
    elseif isa(x, Second)
        (6, x.value)
    elseif isa(x, Millisecond)
        (7, x.value)
    elseif isa(x, Quarter)
        (2, 3 * x.value)
    end
end

function datetime_fieldindex(x)
    if isa(x, Year)
        1
    elseif isa(x, Month)
        2
    elseif isa(x, Day)
        3
    elseif isa(x, Hour)
        4
    elseif isa(x, Minute)
        5
    elseif isa(x, Second)
        6
    elseif isa(x, Millisecond)
        7
    end
end

function timedate_field(x)
    if isa(x, Year)
        (1, x.value)
    elseif isa(x, Month)
        (2, x.value)
    elseif isa(x, Day)
        (3, x.value)
    elseif isa(x, Week)
        (3, 7 * x.value)
    elseif isa(x, Hour)
        (4, x.value)
    elseif isa(x, Minute)
        (5, x.value)
    elseif isa(x, Second)
        (6, x.value)
    elseif isa(x, Millisecond)
        (7, x.value)
    elseif isa(x, Microsecond)
        (8, x.value)
    elseif isa(x, Nanosecond)
        (9, x.value)
    elseif isa(x, Quarter)
        (2, 3 * x.value)
    end
end

function timedate_fieldindex(x)
    if isa(x, Year)
        1
    elseif isa(x, Month)
        2
    elseif isa(x, Day)
        3
    elseif isa(x, Hour)
        4
    elseif isa(x, Minute)
        5
    elseif isa(x, Second)
        6
    elseif isa(x, Millisecond)
        7
    elseif isa(x, Microsecond)
        8
    elseif isa(x, Nanosecond)
        9
    end
end
