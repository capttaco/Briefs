Briefs
======
A framework for making interactive iPhone wireframes.  

_This framework is currently a work in progress. Please contact me with any questions about future status and feature requests._

Follow updates on Twitter: <a href="http://twitter.com/briefsapp">@briefsapp</a>

Rob Rhyne  
<a href="mailto:rob@robrhyne.com">rob@robrhyne.com</a>

***

Installation Notes
==================
Where are the missing files? Oh no, `Briefs` is broken, why is it broken?

It's not broken, the <a href="http://github.com/capttaco/Briefs-data">Briefs-Data</a> project is linked as a `git submodule`. So there are extra steps you have to take to pull down the data model code. The steps you take depend on how you put the project on your computer:

Option 1: I downloaded the `.zip` file
-------------------------------

If you downloaded the bundle, go to the Briefs-Data project, <a href="http://github.com/capttaco/Briefs-data">http://github.com/capttaco/Briefs-data</a>, download that project and place the unzipped contents into the `/data` directory. Open up Xcode and the missing files should have returned.

Option 2: I cloned the repository
--------------------------

If you cloned (or forked) the repository from the public url, then you just have to initialize the submodule.

    git submodule init
    git submodule update

And you're done!


This sounds like a pain in the ass, why did you do it?
------------------------------------------------------

Why is <a href="http://github.com/capttaco/Briefs-data">Briefs-Data</a> a `submodule`? Good question. We wrote it this way to maintain a separate Cocoa library that just reads and writes `Briefs`. Then later, after you've invested time and effort in writing `Briefs`, other savvy developers (perhaps yourself) can write & sell applications that can read your `Briefs.`

And since it's open-source, this ensures that you'll always have access to your data. Nobody likes closed data formats, and it guarantees you can still read your `Briefs` 50 years from now using your hyper-kinetic visor while teleporting to Mars.