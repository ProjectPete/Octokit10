
## Table of Contents



- [Introduction](#Introduction)


  - [The Database](#The_Database)
- [The Sources](#The_Sources)


  - [Top Contributor Winners](#Top_Contributor_Winners)
  - [Guru Winners](#Guru_Winners)
  - [Featured Articles](#Featured_Articles)
  - [Interviews](#Interviews)
  - [Profile Statistics](#Profile_Statistics)
- [The Tools](#The_Tools)
- [The Central Database & Website](#The_Central_Database_amp_Website)
- [The Calculator](#The_Calculator)
- [Summary](#Summary)
- [[Updated for 2017]](#Updated_for_TwentySeventeen)

## <a name="Introduction"></a>Introduction


The [<br>TechNet Wiki Ninja Belts](http://social.technet.microsoft.com/wiki/contents/articles/16313.wiki-ninja-belt-rankings.aspx) are an award initiative for authors of articles on TechNet Wiki. As shown in that link, there are a lot of requirements for each progression up through the belts. These requirements cover numerous activities across TechNet Wiki<br> and also from the [MSDN](http://social.technet.microsoft.com/wiki/contents/articles/20580.wiki-glossary-of-technology-acronyms.aspx#MSDN) profile page statistics. Because this information is scattered and difficult to collect, the work involved<br> in maintaining the Ninja Belt Awards list was becoming unmanageable.



I had been mentioning the need for a "centralized database of everything" for TechNet Wiki activities for several years, as the number of activities grew. But it was the Ninja Belts that were the final straw, which led to the work I am about to describe.



The only way to viably maintain the list of who has what belt, would be to pull all the information into a single relational database source and automate the process of calculating who has which belt.


### <a name="The_Database"></a>The Database


Here is a database diagram of how all the tables relevant to the Ninja Belt calculator. Click to enlarge.



**[update] This has grown considerably since this article was first published]**






[![ ](http://social.technet.microsoft.com/wiki/resized-image.ashx/__size/550x0/__key/communityserver-wikis-components-files/00-00-00-00-05/4101.CaptureWikiDb.PNG)](http://social.technet.microsoft.com/wiki/cfs-file.ashx/__key/communityserver-wikis-components-files/00-00-00-00-05/4101.CaptureWikiDb.PNG)

## <a name="The_Sources"></a>The Sources


Here is a brief explanation of each of the sources of data I used to collect all of this information.


### <a name="Top_Contributor_Winners"></a>Top Contributor Winners


This was one of the most painful sets of data to collect, even though it was all created by myself, and partly database-generated in the first place! I wrote a crawler in the all-mighty<br>[<br>WPF](http://social.technet.microsoft.com/wiki/contents/articles/20580.wiki-glossary-of-technology-acronyms.aspx#WPF), which [thanks to the WebBrowser component] crawls through the  last week's worth of revisions, which is listed<br>[<br>here](http://social.technet.microsoft.com/wiki/contents/articles/default.aspx?QueryType=Updated&PageIndex=1). Unfortunately, the auto-generate doesn't give me the winners, that is a subjective decision I have to make. It simply offers the top 10 most changed articles, from which I select a winner. Also unfortunately, not realizing I would need to crawl this<br> data, I used to heavily tweak the text a lot, so it meant writing a "crawler for my crawler results" was quite a job!



I have now extended my Top Contributor Winners blog generation tool, to allow me to select the winners and THEN generate the final blog. This means I can include the new winners statistics section in the TC blog. This also means I save the winners when generating<br> the blog, without need to crawl the blog any more


### <a name="Guru_Winners"></a>Guru Winners


The TechNet Guru competition is another of my early initiatives, to help celebrate the work that our community brings to the Wiki. Each month, Microsoft employees, WIki councillors and MVPs from many technical categories review and award medals to the authors<br> of new content published on TechNet Wiki. These winners are mostly listed [<br>here](http://social.technet.microsoft.com/wiki/contents/articles/19918.technet-guru-the-most-frequent-award-winners.aspx), but as this is manually maintained, is often outdated. Over recent times, Gurus have been generating their own user pages of winning articles, pages listing winners of different categories, and many blogs have analysed the groups and other stats of<br> our winners.



So to collect this "Guru-win" data, I adapted the techniques used for the Top Contributors Crawler. I made a new crawler for the<br>[<br>Guru Awards blogs](http://blogs.technet.com/b/wikininjas/archive/tags/technet+guru+monthly+competition/default.aspx) urls, which I again would have to manually start it, but would pull the data into the database. Not wanting to bore you too much, this crawler had to go down to each article, to pull out the Wiki User Id, which we tie things into the database<br> with.


### <a name="Featured_Articles"></a>Featured Articles


I wrote another crawler to pull the initial list of Featured Articles from [<br>this wiki page](http://social.technet.microsoft.com/wiki/contents/articles/17840.interview-with-a-wiki-ninja.aspx) that listed all previous featured articles. Now that this is imported, the<br>[<br>Ninja Bloggers](http://social.technet.microsoft.com/wiki/contents/articles/14459.wiki-ninjas-blog-the-contributors.aspx) can simply add a new entry through our Azure [ASP.Net](http://social.technet.microsoft.com/wiki/contents/articles/20580.wiki-glossary-of-technology-acronyms.aspx#ASP_NET) MVC 5 intranet tool, now called the TechNet Wiki Dojo. This<br> has since updated several times, most recently throughout the second half of 2016. This therefore keeps this category of stats up to date, for the next calculator run.


### <a name="Interviews"></a>Interviews


This was pulled with yet another crawler from [<br>this other wiki page](http://social.technet.microsoft.com/wiki/contents/articles/17840.interview-with-a-wiki-ninja.aspx) that lists all past interviews. Again, I added an input form for<br>[<br>Ninja Bloggers](http://social.technet.microsoft.com/wiki/contents/articles/14459.wiki-ninjas-blog-the-contributors.aspx) to add new interviews into the database via our intranet tool. This again keeps the data up to date for future belt calculations.


### <a name="Profile_Statistics"></a>Profile Statistics


This is a little harder than the rest. This information is pulled from the Statistics and Achievements sections of the profile page of each user - [here is mine](http://social.technet.microsoft.com/profile/xaml%20guy/).



Every time we want to run the Belt Calculator, we need to ensure we use the latest set of figures from these pages. Unfortunately, we do not have direct access to any of the databases behind TechNet Wiki or User Profiles, which is understandably for privacy<br> reasons. However, using a crawler to pull the data from each user's profile page, based on user id (http://social.technet.microsoft.com/wiki/**149154**/ProfileUrlRedirect.ashx) would be a slow and painful exercise to do every time.



Thankfully, in their wisdom, Microsoft serve the data that is generated into the profile page from a [JSON](http://social.technet.microsoft.com/wiki/contents/articles/20580.wiki-glossary-of-technology-acronyms.aspx#JSON) based web service. Once<br> you know where and how, it's a simple matter of calling the same service to pull the raw data into my own system. Known users are users who have won an award, or had a featured article or interview. My new multi-threaded JSON client application can pull all<br> known users (at time of writing, just over 350) in under 10 seconds! Uploading all this data into the Azure database then takes considerably longer, but I'm working on reducing that too.


## <a name="The_Tools"></a>The Tools


As discussed above, each of these sets of data had to be imported, and it was past the point of being able to do it manually. So I wrote a bunch of [mostly single-use] tools, to crawl web pages for the data instead.


[![ ](http://social.technet.microsoft.com/wiki/resized-image.ashx/__size/329x0/__key/communityserver-wikis-components-files/00-00-00-00-05/1374.CaptureTools.PNG)](http://social.technet.microsoft.com/wiki/cfs-file.ashx/__key/communityserver-wikis-components-files/00-00-00-00-05/1374.CaptureTools.PNG)


For a brief introduction of how to do this, you can read [<br>this MSDN Gallery sample](http://code.msdn.microsoft.com/windowsdesktop/WPF-Automation-Loading-6ae6c88a) that I uploaded a while ago, which explains some basic techniques for web page manipulation. However, in most of my cases, it is quicker to fall back on old techniques like scanning through the raw<br>[<br>html](http://social.technet.microsoft.com/wiki/contents/articles/20580.wiki-glossary-of-technology-acronyms.aspx#HTML), looking for markers, like the start of a section or a bullet point, then finding text between expected HTML tags, for article/author name and article/author<br>[<br>URL](http://social.technet.microsoft.com/wiki/contents/articles/20580.wiki-glossary-of-technology-acronyms.aspx#URL).


## <a name="The_Central_Database_amp_Website"></a>The Central Database & Website


Once all this data was collected into a single SQL database, the first obvious need was to provide access to the data for our<br>[<br>bloggers](http://social.technet.microsoft.com/wiki/contents/articles/14459.wiki-ninjas-blog-the-contributors.aspx) and [<br>councillors](http://social.technet.microsoft.com/wiki/contents/articles/5075.technet-wiki-community-council-members.aspx).



I have already been providing data about my weekly crawls from an Azure based website for over a year. There is a feature within, to generate the weekly crawl winners blog, and even a translation tool, which can generate the blog in any language that it<br> is loaded with.



This was a great opportunity to bring the site up to [MVC](http://social.technet.microsoft.com/wiki/contents/articles/20580.wiki-glossary-of-technology-acronyms.aspx#MVC) 5 and EF6, which was a very painless exercise. As mentioned above, it has<br> been reworked several times since and is constantly being updated with extra tools and features.






[![ ](http://social.technet.microsoft.com/wiki/resized-image.ashx/__size/550x0/__key/communityserver-wikis-components-files/00-00-00-00-05/5314.CaptureAzure.PNG)](http://social.technet.microsoft.com/wiki/cfs-file.ashx/__key/communityserver-wikis-components-files/00-00-00-00-05/5314.CaptureAzure.PNG)


I've tried to make it as simple as possible for bloggers to add Featured Articles and Interviews, with a link from the home page.



You'll also notice a section for Guru awards which includes tools to monitor the voting process, but that's another story :)



The snapshot above is very old, the menu is much longer now, depending on a user's privileges. Some trade secrets too, including two how-to videos, which I can't share here. If you are reading this because you are helping me with the awards or calculator,<br> please ask me for more info.



MVC is the most excellent way to quickly produce a website off of the back of a database, I highly recommend it to anyone who faces any kind of database driven web development. Although being one of the UK's longest ASP.NET developers, I can happily say<br> I am delighted to add this to my core set of development skills.


## <a name="The_Calculator"></a>The Calculator


Finally, we get to the calculator, which this article was meant to be about!



Off of the back of all of that collected information, with up to date profile statistics, we can finally run the calculator. For this I tried several coding styles, but found by far the quickest to be simply doing some multi-threaded crunching through each<br> user to see if they pass the next level belt requirements. This takes seconds, with which I then update the User table, with any new Belt Ids. I also output the results as an ordered Data Grid, and also a plain text list - for copying out to emails, etc.


[![ ](http://social.technet.microsoft.com/wiki/resized-image.ashx/__size/389x0/__key/communityserver-wikis-components-files/00-00-00-00-05/6545.CaptureCalculator.PNG)](http://social.technet.microsoft.com/wiki/cfs-file.ashx/__key/communityserver-wikis-components-files/00-00-00-00-05/6545.CaptureCalculator.PNG)

## <a name="Summary"></a>Summary


It was indeed been a hard slog to collect all this information into one central source, and build the tools to create and use it. The result however has kept us running these awards and the only way we would have been able to keep the calculator. It has<br> also, been a lot of fun, and helped me upgrade my skill set once again to the latest and greatest MS has to offer. I feel we are very lucky to have such a large community of developers, reaching back almost a whole generation now.<br>






## [Updated for 2017]


So much has changed since this was written. The second half of 2016 was particularly turbulent, with major rewrites and new features. There are changes every month.



**Most people who read this article these days would be those taking on one of these tasks. So I wish you the very best and as I've probably already said to you - don't hesitate to ask me any questions you need, to help you help us!**
