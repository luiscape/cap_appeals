CAP Appeals Crowdsourcing Effort
================================

This repository contains all the code used in the crowd-sourcing initiative to exctract the figures from all the appels documents made public by OCHA.


Problem
-------

There are **492** appeals about **74 countries** or regions. There are *827* documents in the [CAPs website](http://www.unocha.org/cap/appeals/by-appeal/results?page=0). (A good number are duplicates in different formats, PDF / DOC).

![Comparing appeals by type.](plot/bar_plot_source.png)

After adding colors to each country, we can see the variety of countries represented in each report group.
![Comparing appeals by type and colored by country.](plot/bar_plot_country.png)

Here we can see the distribution of reports per country (or crisis).
![Comparing the type of appeals by country / crisis.](plot/steps_country.png)

South Africa (30) seems to be the country that has the largest number of appeals, followed by South Sudan (26) and Somalia (22).
![Number of appeals per country.](plot/bar_plot_appeals_per_country.png)



Solution
--------

The appeal documents are usually PDF files that contain important figures about the humanitarian response to a crisis. Among the most important figures is the 'Number of People Affected', 'Number of People in Need', and the 'Number of People Reached', among others.

We could try an approach to extract those figures automatically. The problem, however, is that at throughout the 10 years of documentation available, there have been many ways to reference those figures, ranging from layout to linguistic differences. Moreover, those figures don't follow a strict methodology, and have been assembled by a combination of discretionary and political desicion-making.

With that in mind, we thought that humans reading the documents could be one of the best ways of extracting those figures accuratelly. Considering the number of documents that need to be analyzed, we opted for a crowdsourcing approach.

[Crowdcrafting](http://crowdcrafting.org/) is an open-source application created by the [Open Knowledge Foundation](http://blog.okfn.org/2013/09/17/crowdcrafting-putting-citizens-in-control-of-citizen-science/) to make easier the process of creating crowd-sourcing applications. This repository contains resources necessary for creating a Crowdcrafting application that reads PDF documents, displays them to users, and asks them questions about a certain page. The idea is to count with the help of volunteers to extract and categorize the data out of the appeals documents using volunteers' cognition and judgement.



Usages
-----

This repository contains scripts mainly written in `R`. It also uses the package [xpdf](http://www.foolabs.com/xpdf/download.html) to convert PDF to plain text to do text analysis.