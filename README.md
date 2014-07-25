CAP Appeals Crowdsourcing Effort
================================

This repository contains all the code used in the crowd-sourcing initiative to exctract the figures from all the appels documents made public by OCHA.


Problem
-------

There are appeal documents about **74 countries** or regions.

![Comparing appeals by type.](plot/bar_plot_source.png)

After adding colors to each country, we can see the variety of countries represented in each report group.
![Comparing appeals by type and colored by country.](plot/bar_plot_country.png)

Finally, here we can see the distribution of reports per country (or crisis).
![Comparing the type of appeals by country / crisis.](plot/steps_country.png)


Solution
--------

[To come ...]



Usage
-----

This repository contains scripts mainly written in `R`. It also uses the package `[xpdf](http://www.foolabs.com/xpdf/download.html)` to convert PDF to plain text to do text analysis.