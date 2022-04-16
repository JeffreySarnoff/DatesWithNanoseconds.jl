module TimeDates

export TimeDate, periods, timedate2rata, rata2timedate

using Dates
using Dates: AbstractDateTime, CompoundPeriod, value, days, tons, toms


include("timedate.jl")
include("constants.jl")
include("basefuncs.jl")
include("accessors.jl")
include("compare.jl")
include("datesfuncs.jl")
include("arithmetic.jl")
include("rounding.jl")
include("parsing.jl")
include("datetypes.jl")         # enhance programming with Date, Time, DateTime
include("compoundperiod.jl")
include("ranges.jl")            # with CompoundPeriod steps
include("namedtuples.jl")       # alternative representation using NamedTuple

end  # TimeDates
