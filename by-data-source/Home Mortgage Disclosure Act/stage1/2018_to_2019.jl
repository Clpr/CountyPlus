#===============================================================================
HMDA DATA PROCESSING: 2018 - 2019
===============================================================================#
hmda = include("1819/src/HMDA.jl")


# ------------------------------------------------------------------------------
# load configs
env = hmda.EnvVars()
hmda.load!(env)


# ------------------------------------------------------------------------------
# process year by year
for year in 2018:2019

    ya = hmda.YearAggregator(
        env.all_fips |> collect |> sort,
        Dict{String,String}(env.aggs.item .=> env.aggs.continuity)
    )
    verbose = true

    verbose && println("year: ", year, " ", "-"^80)

    # csv file dir
    fdir = env.data_dir * "/" * env.datafiles_unzipped[year]

    # count how many lines
    verbose && println("0. file: ", fdir)
    verbose && println("1. counting how many lines...")
    nlns = countlines(fdir)
    verbose && println("2. #lines = ", nlns)


    # streaming read
    verbose && println("3. streaming the file...")
    tic = time()
    ctr = 1
    fp  = open(fdir,"r")
    pb  = hmda.ProgressBar(eachline(fp), total = nlns, width = UInt64(80))
    for ln in pb
        if ctr > 1
            # push data to the aggregator
            hmda.pushrow!(ya,env,year,ln)
        end
        ctr += 1
    end # ln
    verbose && hmda.@printf("4. elapsed: %.1f min\n", (time() - tic) / 60)

    # postprocess
    close(fp)
    verbose && println("5. file I/O closed")


    # compile aggregation table
    df = collect(ya, year, env)
    hmda.savedta!(df, string("output/final",year,".dta"))

end # year



