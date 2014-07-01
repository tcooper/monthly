monthly
=======

Scripts used to generate monthly reporting metrics

* utilization.R -  just change xvec.start and xvec.stop to whatever month's 
    bounds are of interest and run directly against the *-all.incl file
* clog-plot.R - same as utilization.R

Plotting Utilization
--------------------
1. Edit utilization.R and update the date range defined near top (`xvec.start` and `xvec.stop`)
2. Run `./utilization.R ./gordon-ongoing.incl` to generate ./gordon-ongoing.incl.png (the png will be created in whatever directory contains the input file)
3. Transfer the *-ongoing.incl.png to wherever you'd like

Plotting Queue Cloggedness
--------------------------
1. Edit clog-plot.R and update the date range defined near top (`xvec.start` and `xvec.stop`)
2. Run `./clog-plot.R ./gordon-clog.incl` to generate ./gordon-clog.incl.png (the png will be created in whatever directory contains the input file)
3. Transfer the *-clog.incl.png to wherever you'd like

Annotating Queue Clog Plot
--------------------------
1. Figure out the time and date of interest from the epoch timestamp in the *-clog.incl file
2. cd to the appropriate database of queue information (/oasis/projects/nsf/use300/glock/machinestate/)
3. Run `clog-probe.sh 201405261300.db` to see how much of a jam each user was contributing on 2014-05-26 at 13:00
