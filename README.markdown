Briefs
======
A toolkit for making interactive iPhone wireframes. (<a href="http://twitter.com/briefsapp">@briefsapp</a> on Twitter)

Contact
-------

This framework is currently a work in progress. Please contact me with any questions about future status and feature requests.

<a href="mailto:rob@robrhyne.com">rob@robrhyne.com</a>  


About
=====
The Briefs toolkit was created for rapidly building & iterating app prototypes for the iPhone. These prototypes run directly on the phone, like actual apps, but require much less time and code to produce. Less code means faster cycles and cheaper development.

The purpose of Briefs is to create better apps that have a tested interaction design before they are built. Unlike traditional mockups, briefs are used just like an actual app not just seen. And because they use the same frameworks that regular apps are built upon, briefs can potentially take advantage of animation, device rotation and gestures. You can even design the experience around app interruption due to an incoming phone call. Thinking about these interactions will ensure a more thought out experience for your users.


Design
======
At it's core, each brief is merely a text file that references a series of static images. These text files carry the extension `.brieflist` and can be compacted, which dereferences the images embedding the raw data into the brief. This allows for only a single file to be transferred between you and your testers.

Scenes
------
The organization of a brief is divided into `scenes` which represent a single state for any given screen inside of your application. Each `scene` contains a transition style that controls how the image associated with the `scene` appears and exits. 

Actors
------
Controls and events are modeled as `actors` that belong to a given `scene`. An `actor` can also contain an image reference that is optional. The location, size and action must all be defined for an `actor`. (0,0) starts in the top-left and the size is specified in pixels.

Briefcasts
----------
A `briefcast` is a way to share your briefs with the world. It's a standard RSS 2.0 feed that uses enclosures (much like podcasts) to embed briefs inside. The `briefs.app` can read this feed and allows you to download the brief onto your device. With `briefcasts` you don't need Xcode to embed your briefs: instead copy new versions of your briefs to your `briefcast`, then pull them down on the device.


Components
==========
Briefs is comprised of three major projects, all hosted on GitHub. There is (1) this project, Briefs.app, (2) the [Briefs-data][data] project and (3) the [Briefs-util][util] project. All are combined to create the Briefs ecosystem.

[data]: http://github.com/capttaco/Briefs-data
[util]: http://github.com/capttaco/Briefs-util 

Briefs.app
----------
First and foremost, Briefs is an application that runs on your iPhone. For testers of your briefs, this is the primary touch point of the toolkit. From the application, a user can organize briefs stored on the device, download new briefs using `briefcasts` and _play_ those briefs on the device. The code inside of `Briefs.app` is responsible for playing and storing `briefs.`

The `BFPresentationDispatch` is a singleton class that launches a new brief after it is selected by the user. It contains a reference to a `BFSceneViewController`, the class that is responsible for rendering the current `scene` as it is selected by user action.

Briefs-data
-----------
The `Briefs-data` project is a Cocoa library that reads, writes and manages briefs data. It is maintained as a [separate project][data] to enable enterprising Cocoa developers to build products that support the briefs data format. More information can be found on [its project page][data].

Briefs-util
-----------
`Briefs-util` is a series of utilities for _authoring_ briefs. It includes a parser called `BS` that compiles `.bs` or _briefscripts_ into the `.brieflist` format. Briefscript is a more concise language built for speed and readability. More information can found on [its project page][util]. 


Getting Started
===============
After you download the source, either by cloning the repository or downloading the source manually, open the project in Xcode. (if you are seeing missing files, see the section *Installation Notes* below to get them to appear) Once open, a quick *Build & Go* will launch `briefs.app` in the simulator.

1. Write a Brief
----------------
Start building your brief, first by visiting the [Briefs-util][util] project and downloading the `bs` parser. Read the documentation on the [project page][util] for writing a `.bs` file. The following code fragment is from a `.bs` file:

    start: Springboard
    defaultImage: imgs/blank.png

    scene: Springboard
    image: imgs/0-springboard.png

        actor: Pick SMS App    
            position: 19, 25 
                size: 55, 55   
              action: goto(Main)

Then compile the script (in the example, we're assuming the name `foo.bs`) running the following in `terminal.app`:
    
    bs foo.bs > foo-source.brieflist
    
This will compile your script into a `foo-source.brieflist` file.

2. Compact the Brief
--------------------
Inside Xcode, switch your target to `BriefsCompactor` and build the project. (You might have to switch the SDK) Copy the resulting script, `compact-briefs` onto your local path, for instance in `/usr/local/bin/`. Once on your path, go back to `terminal.app` and run:

    compact-briefs foo-source.brieflist foo.brieflist
    
This will create a single file `foo.brieflist` that contains all of the raw image data.

3. Copy into Briefs.app
-----------------------
Back in Xcode (don't forget to switch your target back to `Briefs`), copy `foo.brieflist` into your Xcode project, under the group _My Briefs_. Make sure in the _Briefs_ target the file is being copy under the _Copy Bundle Resources_ task. Once again, select _Build & Go_ and when `Briefs.app` launches you should see `foo.brieflist` in the table. Select the brief and see your prototype come to life.

Optionally, Create a Briefcast
------------------------------
Using the code below as a reference, change the relevant information and include references to your briefs inside the `items` section. It is important that you include a fully qualified path to your brief!

    <?xml version="1.0"?>
    <rss version="2.0">
        <channel>
            <title>Briefcast Demo</title>
            <link>http://giveabrief.com/briefcast/</link>
            <description> Demonstrate how awesome it is to use a briefcast to get briefs on the iPhone.</description>
            <language>en-us</language>
            <pubDate>Thu, 12 Nov 2009 03:05:00 GMT</pubDate>
            <lastBuildDate>Thu, 12 Nov 2009 03:05:00 GMT</lastBuildDate>
            <item>
                <title>Kitchen Shopping Sketch</title>
                <enclosure url="http://giveabrief.com/cast/shopping.brieflist" length="29230" type="application/brief" />
                <description>An example brief showing how you can use scanned-in pencil sketches.</description>
                <pubDate>Sun, 13 Sep 2009 03:05:00 GMT</pubDate>
                <guid>http://giveabrief.com/cast/1#item1</guid>
            </item>
        </channel>
    </rss>

Copy this `.xml` file to your server in a publicly accessible location, along with any referenced briefs.


Installation Notes
==================
Where are the missing files? Oh no, `Briefs` is broken, why is it broken?

It's not broken, the [Briefs-Data][data] project is linked as a `git submodule`. So there are extra steps you have to take to pull down the data model code. The steps you take depend on how you put the project on your computer:

Option 1: I downloaded the `.zip` file
--------------------------------------

If you downloaded the bundle, go to the Briefs-Data project, <http://github.com/capttaco/Briefs-data>, download that project and place the unzipped contents into the `/data` directory. Open up Xcode and the missing files should have returned.

Option 2: I cloned the repository
---------------------------------

If you cloned (or forked) the repository from the public url, then you just have to initialize the submodule.

    git submodule init
    git submodule update

And you're done!


This sounds like a pain in the ass, why did you do it?
------------------------------------------------------

Why is [Briefs-Data][data] a `submodule`? Good question. We wrote it this way to maintain a separate Cocoa library that just reads and writes `Briefs`. Then later, after you've invested time and effort in writing `Briefs`, other savvy developers (perhaps yourself) can write & sell applications that can read your `Briefs.`

And since it's open-source, this ensures that you'll always have access to your data. Nobody likes closed data formats, and it guarantees you can still read your `Briefs` 50 years from now using your hyper-kinetic visor while teleporting to Mars.