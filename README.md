# Bwoken ![build status](https://secure.travis-ci.org/bendyworks/bwoken.png?branch=master)

Runs your UIAutomation tests from the command line for both iPhone and iPad, in the simulator or on your device.

Supports coffeescript and javascript.

![screenshot](https://raw.github.com/bendyworks/bwoken/master/doc/screenshot.png)


## On the Command Line

### Running tests

Make sure bwoken is <a href="#installation">properly installed</a>. Then, build your project and run all your tests via:

<pre><code># will build and run all of your tests
$ bwoken test

# will run one file, relative to integration/coffeescript/{iphone,ipad}/
#  (note: no file extension)
$ bwoken test --focus some_test # runs this test on (iphone and ipad) OR (connected iDevice)
$ bwoken test --focus some_test --family iphone
</code></pre>

### Simulator or Device?

To run bwoken tests on your device, just plug it in! And if you want to run tests in the simulator, just unplug it!

<pre><code># without a device connected, will run on the simulator:
$ bwoken test

# with a device connected, will run on the device:
$ bwoken test

# with a device connected, will run on the simulator:
$ bwoken test --simulator
</code></pre>

Your tests will look something like this:

<pre><code>$ bwoken test
Building.............................................................................
.....................................................................................
.....................................................................................
.....................................................................................
.....................................................................................
.....................................................................................
.....................................................................................
................................................................................
Build Successful!

iphone  favorites.js
Start:  Favoriting a repository
Debug:  tap tableViews["Repositories"].cells["CITravis by Travis-ci"]
Debug:  tap navigationBar.rightButton
Debug:  tap actionSheet.elements["Add"]
Debug:  tap navigationBar.leftButton
Debug:  tap navigationBar.elements["Favorites"]
Debug:  navigationBar.elements["Favorites"].scrollToVisible
Debug:  tap navigationBar.elements["All"]
Pass:   Favoriting a repository
Start:  Unfavoriting a repository
Debug:  tap navigationBar.elements["Favorites"]
Debug:  tap tableViews["Repositories"].cells["CITravis by Travis-ci"]
Debug:  tap navigationBar.rightButton
Debug:  tap actionSheet.elements["Remove"]
Debug:  tap navigationBar.leftButton
Debug:  should be true null
Debug:  tap navigationBar.elements["All"]
Pass:   Unfavoriting a repository

Complete
 Duration: 23.419741s
</code></pre>

### All the switches

Here's a list of all the switches that bwoken takes for the `test` command:

<pre><code>
$ bwoken test -h
[...]
        --simulator       Use simulator, even when an iDevice is connected
        --family          Test only one device type, either ipad or iphone. Default is to test on both
        --scheme          Specify a custom scheme
        --product-name    Specify a custom product name (e.g. --product-name="My Product"). Default is the name of of the xcodeproj file
        --formatter       Specify a custom formatter (e.g., --formatter=passthru)
        --focus           Specify particular tests to run
        --clobber         Remove any generated file
        --skip-build      Do not build the iOS binary
        --verbose         Be verbose
    -h, --help            Display this help message.
</code></pre>

## In Your Code

### Like Javascript?

Sometimes we'd like to have some javascript help us out. For example, what if you'd like [Underscore.js](http://underscorejs.org) in your test suite? Simple! Just put it in <code>integration/javascript</code> and import it in your test:

<pre><code>#import "../underscore.js"
</code></pre>

### Bring in Libraries!

Wanna bring in [tuneup.js](https://github.com/alexvollmer/tuneup_js), [mechanic](https://github.com/jaykz52/mechanic), or [underscore](http://underscorejs.org) without manually downloading them first? Just use `#github` instead of `#import`:

<pre><code>#github "jashkenas/underscore/underscore.js"
#github "alexvollmer/tuneup_js/tuneup.js"
#github "jaykz52/mechanic/src/mechanic-core.js"
</code></pre>


## Installation

### Create an iOS project

If you don't have an iOS project already, go ahead and create it. If you already have a project, no worries: you can install bwoken at any point.

Ensure your project is in a workspace rather than simply a project:

* In Xcode, select File -&gt; Save as workspace...
* Save the workspace in the same directory as your .xcodeproj file

Note: This is done automatically if you use [CocoaPods](http://cocoapods.org/). I highly suggest you do!

### Prerequisites

Ensure Xcode is up-to-date.

Install rvm via <a href="https://rvm.io/rvm/install/">the instructions</a>. Ensure your after_cd_bundler rvm hook is enabled:

<pre><code>$ chmod u+x ~/.rvm/hooks/after_cd_bundler
</code></pre>

### Install

In the terminal, inside the directory of your project (e.g., you should see a <code>ProjectName.xcodeproj</code> file), create an <code>.rvmrc</code> file and trigger its use:

<pre><code>$ echo '2.0.0' &gt; .ruby-version
$ echo 'my_project' &gt; .ruby-gemset
$ cd .
</code></pre>

Install bundler (a ruby library dependency manager) and init:

<pre><code>$ gem install bundler # idempotent; might already be installed and that's ok
$ bundle init
</code></pre>

This will create a <code>Gemfile</code>. Add bwoken to it and bundle:

<pre><code>$ echo "gem 'bwoken', '2.0.0.beta.1'" &gt;&gt; Gemfile
$ bundle
</code></pre>

The last installation step is to initialize the bwoken file structure:

<pre><code>$ bwoken init
</code></pre>

Now, you can start <a href="#usage">using it!</a>

#### The Dirty Little Installation Method

Technically, you can skip this entire Installation section and just run `sudo gem install bwoken && bwoken init`. This is listed here for completeness, but you really shouldn't install gems this way.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
