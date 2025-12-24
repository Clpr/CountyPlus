module HMDA
# ==============================================================================
using Printf
using Statistics

import CSV
import YAML
import DataFrames as pd
import DataStructures as ds
using  ZipFile
import ProgressBars: ProgressBar
using  ReadStatTables

# ------------------------------------------------------------------------------


#=++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SECTION: ALIAS & CONSTANTS

## Notes
- "joint" has been introduced, but classified to being invalid to be consistent
- races have been more detailed. to be consistent x years, combine:
    - white: 5
    - black: 3
    - asian: 2,21,22,23,24,25,26,27
    - valid: non-missing & not equal to 6 or 7

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#
StreamCounter = ds.Accumulator{Union{String,Int,Missing,Nothing},Int}
const ALL_STATUS = ("complete","approval","denial")
const ALL_REASONS = (
    "d2incratio", # code: 1
    "employhist",
    "credithist",
    "collateral",
    "insuffcash", # code: 5
    "unveriinfo",
    "appincompl",
    "minsdenied",
    "otherreaso", # code: 9
)
const ALL_SEXES = ("male", "female", "valid")
const ALL_RACES = (
    "white",
    "black",
    "asian",
    "valid",
)





#=++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SECTION: GENERIC HELPERS
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#
function destring(x::AbstractString)::Union{Int,Float64,Nothing}
    # parse a string to a numeric value, either Int or Float64
    # if the string is impossible to be parsed, the return a `nothing`
    # note: NaN::Float64 may be returned if x is one of "Nan","NaN","nan"
    y = tryparse(Int, x)
    if isnothing(y)
        return tryparse(Float64, x)
    else
        return y
    end
end
# ------------------------------------------------------------------------------
function splitrow(rowStr::String)
    # wrap the row split operation with special care and processing for HMDA dat
    # notes: no quote marks in after-2017 data, and no string-dtype column that
    #        contains comma marks. so it is safe to do the split by vanilla
    #        comma mark. I also have scanned all data files to check such
    #        errors and found none of them.
    return split(rowStr |> strip, ",")
end
# ------------------------------------------------------------------------------
function getdtype(typeStr::AbstractString)::DataType
    s = typeStr |> strip |> lowercase
    return if s == "int"
        Int
    elseif s ∈ ("float","double")
        Float64
    elseif s ∈ ("str","string")
        String
    elseif s == "missing"
        Missing
    elseif s == ""
        Nothing
    else
        error("cannot parse type string: ",typeStr)
    end
end
# ------------------------------------------------------------------------------
function savedta!(df::pd.DataFrame,fdir::String)
    # a wrapper, may change backend later
    ReadStatTables.writestat(fdir, df)
    return nothing
end
# ------------------------------------------------------------------------------
function split_fips(fips5digit::Int)::Tuple{Int,Int}
    # split a 4-digit state-county FIPS code to 2-digit state FIPS and 3-digit
    # county FIPS code

    @assert 1001 <= fips5digit <= 56045 "FIPS not shoul >= 1001 and <= 56045"

    fips_state  = floor(Int,fips5digit / 1000)
    fips_county = fips5digit % 1000
    return fips_state, fips_county
end









#=++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SECTION: CONFIG CLASSES
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#
Base.@kwdef mutable struct EnvVars

    # dir of original data files
    data_dir::String = "../HMDA data - raw/HMDA 18-19 allrecords/"

    # data as zip archive
    datafiles_zip::Dict{Int,String} = Dict{Int,String}(
        2018 => "2018_public_lar_three_year_csv.zip",
        2019 => "2019_public_lar_three_year_csv.zip",
    )

    # data file after inflation
    datafiles_unzipped::Dict{Int,String} = Dict{Int,String}(
        2018 => "2018_public__lar_three_year.csv",
        2019 => "2019_public_lar_three_year_csv.csv",
    )

    # master file for merging with other year-county data
    master_file::String = "1819/options/fips.csv"

    # a set of all FIPS for checking if a county is included in our sample
    all_fips::Set{Int} = Set()

    # describes how to process each year
    process_specs::String = "1819/options/process_specs.csv"

    # tells which aggregators/summarizers should be defined during aggregation
    # unified across year for code re-usability
    aggregator_file::String = "1819/options/aggregators.csv"

    # variable list in final cleaned data
    datadict_final::String = "1819/options/datadict_final.csv"

    # --------------------
    # master table for data merging
    mtab::pd.DataFrame = pd.DataFrame()

    # year-specific settings, guides for data cleaning
    spec::pd.DataFrame = pd.DataFrame()

    # aggregator names & dtypes
    aggs::pd.DataFrame = pd.DataFrame()

    # variable list i nfinal cleaned data
    final::pd.DataFrame = pd.DataFrame()

end # EnvVars
# ------------------------------------------------------------------------------
function Base.show(io::IO, env::EnvVars)
    println(io, "Env variables:")
    for fname in fieldnames(EnvVars)
        fval = getfield(env,fname)
        if isa(fval, Dict)
            println(io, "- ", fname, ": ")
            for (_k,_v) in fval
                println(io, _k, " => ", _v)
            end
        elseif isa(fval, pd.DataFrame)
            println(io, "- ", fname, ": a DataFrame")
        else
            println(io, "- ", fname, ": ", fval)
        end
    end
    return nothing
end
# ------------------------------------------------------------------------------
function load!(env::EnvVars)
    # read in data frames according to specified paths

    env.mtab = CSV.read(env.master_file, pd.DataFrame, header = 1)
    env.all_fips = env.mtab.fips |> Set

    env.spec = CSV.read(env.process_specs, pd.DataFrame, header = 1)
    env.spec[!, :vname_final] = [
        ismissing(newname) ? oldname : newname
        for (oldname,newname) in zip(
            env.spec.variable, 
            env.spec.variable_harmonized
        )
    ]

    env.aggs = CSV.read(env.aggregator_file, pd.DataFrame, header = 1)
    
    env.final = CSV.read(env.datadict_final, pd.DataFrame, header = 1)

    return nothing
end
# ------------------------------------------------------------------------------
Base.@kwdef mutable struct SummarizerCont

    # sample size
    n      ::Int = 0
    n_valid::Int = 0

    # if invalid, count by case
    n_miss::Int = 0
    n_nan ::Int = 0
    n_none::Int = 0
    n_inf ::Int = 0

    # statistics, only among valid entries
    min  ::Union{Float64,Nothing} = +Inf # min{x}
    max  ::Union{Float64,Nothing} = -Inf # max{x}
    sum  ::Union{Float64,Nothing} = 0.0  # ∑x
    sumsq::Union{Float64,Nothing} = 0.0  # ∑x^2

end
# ------------------------------------------------------------------------------
function Base.sum(sc::SummarizerCont)::Float64
    return sc.sum
end
# ------------------------------------------------------------------------------
function Statistics.mean(sc::SummarizerCont)::Float64
    return sc.sum / sc.n_valid
end
# ------------------------------------------------------------------------------
function Statistics.var(sc::SummarizerCont ; corrected::Bool = true)

    μx  = sc.sum / sc.n_valid
    μx² = sc.sumsq / sc.n_valid
    σ²_biased = μx² - μx ^ 2

    return if corrected
        σ²_biased * sc.n_valid / (sc.n_valid - 1)
    else
        σ²_biased
    end
end
# ------------------------------------------------------------------------------
function Statistics.std(sc::SummarizerCont ; corrected::Bool = true)
    return sqrt(Statistics.var(sc, corrected = corrected))
end
# ------------------------------------------------------------------------------
function Base.show(io::IO, sc::SummarizerCont)

    stdval = sc.n_valid < 2 ? NaN : Statistics.std(sc,corrected = true)

    println(io,"Summarizer for a continuous variable:")
    @printf(io,"- #obs          = %d\n", sc.n)
    @printf(io,"- #obs valid    = %d\n", sc.n_valid)
    @printf(io,"- #obs missing  = %d\n", sc.n_miss)
    @printf(io,"- #obs NaN      = %d\n", sc.n_nan)
    @printf(io,"- #obs nothing  = %d\n", sc.n_none)
    @printf(io,"- #obs +/-Inf   = %d\n", sc.n_inf)
    @printf(io,"- min  = %.3f\n", sc.min)
    @printf(io,"- max  = %.3f\n", sc.max)
    @printf(io,"- mean = %.3f\n", Statistics.mean(sc))
    @printf(io,"- std  = %.3f\n", stdval)
    return nothing
end
# ------------------------------------------------------------------------------
function Base.push!(
    sc::SummarizerCont, 
    val::Union{Float64,Int,Missing,Nothing}
)
    # add a new observation to the summarizer

    sc.n += 1

    if ismissing(val)
        sc.n_miss += 1
    elseif isnothing(val)
        sc.n_none += 1
    else # Float64
        if isinf(val)
            sc.n_inf += 1
        elseif isnan(val)
            sc.n_nan += 1
        else
            # normal case
            sc.n_valid += 1

            sc.min = min(val,sc.min)
            sc.max = max(val,sc.max)
            sc.sum   += val
            sc.sumsq += val ^ 2
        end
    end

    return nothing
end








#=++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SECTION: CLASS-DEPENDENT HELPERS
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#













#=++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SECTION: AGGREGATION CLASSES
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#
mutable struct YearAggregator

    # (county 5-digit FIPS, variable name) indexed accumulators/summarizers
    
    n_county  ::Int
    n_variable::Int

    dat::Dict{
        Tuple{Int,String},
        Union{
            SummarizerCont,
            StreamCounter
        }
    }

    function YearAggregator(
        countyfips   ::AbstractVector{Int},  # vec of unique 5-digit fips code
        varname2dtype::Dict{String,String}   # specifies variable & their types
    )
        dat = Dict{
            Tuple{Int,String},
            Union{
                SummarizerCont,
                StreamCounter
            }
        }()

        for (fips,(vname,dtype)) in Iterators.product(countyfips,varname2dtype)

            dat[(fips,vname)] = if dtype == "discrete"
                StreamCounter()
            elseif dtype == "continuous"
                SummarizerCont()
            else
                error("unsupported dtype: ", dtype, " for variable: ", vname)
            end
        end # for
        new(
            length(countyfips),
            length(varname2dtype),
            dat
        )
    end
end
# ------------------------------------------------------------------------------
function Base.show(io::IO, ya::YearAggregator)
    @printf(io,
        "Year aggregator for %d county * %d variables",
        ya.n_county,
        ya.n_variable
    )
    return nothing
end
# ------------------------------------------------------------------------------
function Base.getindex(ya::YearAggregator, k::Tuple{Int,String})
    return ya.dat[k]
end
# ------------------------------------------------------------------------------
function Base.push!(
    ya      ::YearAggregator, 
    fips    ::Int,
    vname   ::String,
    val2push::Union{String,Int,Float64,Missing,Nothing}
)
    if !haskey(ya.dat,(fips,vname))
        # note: since 2018, many military/school districts that have FIPS are
        #       also reported in HMDA but we do not consider these special
        #       regions. all accepted counties are managed by the master table.
        #       it is okay to see numerous warnings when running the script.
        @warn @sprintf("(%d,%s) not exist. skipped",fips,vname)
        return nothing
    end

    record = ya.dat[(fips,vname)] |> Ref

    if isa(record[],StreamCounter)
        ds.inc!(record[],val2push)
    elseif isa(record[],SummarizerCont)
        push!(record[],val2push)
    else
        error("unknown record type: ",typeof(record[]))
    end
    return nothing
end
# ------------------------------------------------------------------------------
function Base.collect(
    ya  ::YearAggregator, 
    year::Int, 
    env ::EnvVars
)::pd.DataFrame
    # compile the aggregator to a dataframe

    # def: a dataframe based on the master table but with extended varibales
    df       = env.mtab |> copy
    df.year .= year
    nobs     = size(df,1)
    _idx     = .!env.final.primary_key
    for (vnm,dtype) in zip(
        env.final.variable[_idx],
        env.final.py_dtype[_idx]
    )
        df[!,vnm] .= zeros(getdtype(dtype), nobs)
    end

    # scan: counties & variables
    for (i,fips) in enumerate(df.fips)

        # action taken by status
        for stu in ALL_STATUS
            df[i,string("hmda_totnum_",stu)] = ya[(fips,"action_taken")][stu]
        end

        # race by status
        for stu in ALL_STATUS, rc in ALL_RACES
            _k1 = string("hmda_totnum_race_",rc,"_",stu) 
            _k2 = string(rc,"_",stu)
            df[i,_k1] = ya[(fips,"race")][_k2]
        end

        # sex by status
        for stu in ALL_STATUS, sx in ALL_SEXES
            _k1 = string("hmda_totnum_sex_",sx,"_",stu)
            _k2 = string(sx,"_",stu)
            df[i,_k1] = ya[(fips,"sex")][_k2]
        end

        # denial reasons
        for re in ALL_REASONS
            _k1 = string("hmda_totnum_denial_",re)
            df[i,_k1] = ya[(fips,"denial_reason")][re]
        end

        # loan amount (by action taken)
        for stu in ALL_STATUS, fn in (:sum,:mean)

            _k1 = string("hmda_lamt_",stu,"_",fn)
            _k2 = string("loan_amount_",stu)

            df[i,_k1] = ya[(fips,_k2)] |> getfield(Statistics,fn)

        end

        # income (by action taken)
        for stu in ALL_STATUS, fn in (:sum,:mean)
            _k1 = string("hmda_inc_",stu,"_",fn)
            _k2 = string("income_",stu)

            df[i,_k1] = ya[(fips,_k2)] |> getfield(Statistics,fn)
        end

        # mortgage rate spread
        begin
            _prefix = "hmda_ratespread_pct_"
            _k2 = (fips,"rate_spread")

            df[i,string(_prefix,"N")]      = ya[_k2].n_valid
            df[i,string(_prefix,"median")] = NaN  # no median actually computed
            df[i,string(_prefix,"mean")]   = mean(ya[_k2])
            df[i,string(_prefix,"sd")]     = std(ya[_k2])

        end

    end # (i,fips)

    return df
end




















#=++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SECTION: YEAR-SPECIFIC SINGLE ROW CLEANING PROCESSES
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#
function pushrow!(
    ya    ::YearAggregator,
    env   ::EnvVars,
    year  ::Int, # for discussion-by-case to wrap all year's processings
    rowStr::String, # raw line string read from original csv file
)

    # strip, split, and map variable names
    record = let
        
        _keys = env.spec.vname_final[env.spec[!,Symbol("in_",year)]]

        # parse data line
        # notes: some str column has comma in its value, so it is not safe to
        #        split the rowStr by single comma but should use \",\", i.e.
        #        two double quotes and a comma sandwiched. meanwhile remember
        #        to remove the leading and final quote mark of the string. This
        #        works because HMDA save all their columns as strings.

        _vals = splitrow(rowStr)

        if length(_keys) != length(_vals)
            error("row string split is wrong, check dlimiter(s).")
        end

        # hint: no missing allowed as it returns missing in some is* functions
        _di = Dict{String,Union{AbstractString,Int,Float64,Nothing}}(
            _keys .=> _vals
        )

        # destring & check missings (all pure-string text variables are dopped)
        # the drop is okay because we have LAR codesheet and use codes across
        # years
        for (k,v) in _di
            _di[k] = destring(v)
        end

        _di
    end
    
    
    # filter. premature return if any violation
    begin
        # any missing of FIPS information?
        # note: 18/19 data directly saves 5-digit FIPS but no state & 3-digit
        if isnothing(record["fips"])
            return nothing
        end
        
        # is it a first-lien loan?
        if record["lien_status"] != 1
            return nothing
        end

        # is it a home improvement loan? (Mian-Sufi's practice)
        # note: code sheet changed since 2018
        if record["loan_purpose"] ∈ (2,4,5)
            return nothing
        end

        # is there loan amount reported?
        if isnothing(record["loan_amount"])
            return nothing
        end

        # is it a second market transaction? is the transaction completed?
        if isnothing(record["action_taken"])
            return nothing
        end
        if record["action_taken"] in (4,5,6)
            return nothing
        end
        @assert 1 <= record["action_taken"] <= 8 @sprintf(
            "impossible action taken code: %d\n",
            record["action_taken"]
        )
    end

    # make: 5-digit FIPS code, and check if FIPS not in the master table
    fips::Int = Int(record["fips"])


    # flag: approved? or denied? (binary after our filtering)
    # notes: approved: 1,2,8; denied: 3,7
    # notes: will be reused multiple times
    # notes: by restriction, a loan can only be approved or denied. cancelled
    #        and other aborted/prematured transactions are ignored by the above
    #        filtering.
    flag_approved::Bool = record["action_taken"] ∈ (1,2,8)

    # aggregation: action taken (approved or denied?)
    begin
        
        # push: must be complete transaction by definition
        push!(ya, fips, "action_taken", "complete")

        # push: approval status
        push!(
            ya,fips,
            "action_taken",
            flag_approved ? "approval" : "denial"
        )

    end

    # aggregation: sex
    begin
        
        # push: only if a record is valid/applicable 
        # because there is a large share of not-applicable or info-not-provided 
        # records. we need to assess data reliability
        # hint: by asserting the type of `record`, there is no missing possible
        #       this is important as ∈ of a missing returns a missing

        flags = Dict{String,Bool}(
            "male"   => record["sex"] == 1,
            "female" => record["sex"] == 2,
        )
        flags["valid"] = flags["male"] || flags["female"]

        for sx in ALL_SEXES
            if flags[sx]
                push!(ya,fips,"sex",string(sx,"_complete"))
                if flag_approved
                    push!(ya,fips,"sex",string(sx,"_approval"))
                else
                    push!(ya,fips,"sex",string(sx,"_denial"))
                end
            end
        end

    end

    # aggregation: race
    begin
        
        flags = Dict(ALL_RACES .=> false)

        # - races have been more detailed. to be consistent x years, combine:
        # - white: 5
        # - black: 3
        # - asian: 2,21,22,23,24,25,26,27
        # - valid: non-missing & not equal to 6 or 7

        for i in "race" .* string.(1:5)
            flags["white"] |= record[i] == 5
            flags["black"] |= record[i] == 3
            flags["asian"] |= record[i] ∈ (2,21,22,23,24,25,26,27)
            flags["valid"] |= if isnothing(record[i])
                false
            else
                0 < record[i] < 6
            end
        end

        for rc in keys(flags)
            if flags[rc]
                push!(ya,fips,"race",string( rc, "_complete" ))
                if flag_approved
                    push!(ya,fips,"race",string( rc, "_approval" ))
                else
                    push!(ya,fips,"race",string( rc, "_denial" ))
                end
            end
        end

    end

    # aggregation: denial reason
    begin

        for (i,reason) in enumerate(ALL_REASONS)

            flag = false
            for j in 1:4
                flag |= record[string("denial_reason",j)] == i
            end

            flag && push!(ya,fips,"denial_reason",reason)

        end

    end

    # aggregation: mortgage rate spread (continuous)
    push!(ya,fips,"rate_spread",record["rate_spread"])


    # aggregation: loan amount (continuous by action status)
    begin
        
        # notes: because exact-zero obs is rare, so ok to plus 1 for logarithm
        #        in the future. it does not hurt in this situation
        _lamt::Float64 = max(record["loan_amount"], 1.0)

        # push: completed loans
        push!(ya,fips,"loan_amount_complete",_lamt)

        # push: loan amount by approval status
        push!(
            ya,fips,
            flag_approved ? "loan_amount_approval" : "loan_amount_denial",
            _lamt
        )

    end

    # aggregation: income (continuous by action status)
    begin
        
        _inc = isnothing(record["income"]) ? nothing : max(record["income"],1.0)

        push!(ya,fips,"income_complete",_inc)
        push!(ya,fips,
            flag_approved ? "income_approval" : "income_denial",
            _inc
        )

    end

    return nothing
end # pushrow!
















# ==============================================================================
end # HMDA