
The [app](app) program is a PERL script which lists and runs OS X Applications 
from the 
[command line](http://blog.teamtreehouse.com/introduction-to-the-mac-os-x-command-line).  
The standard method of opening an application from 
the command line is with the [open](http://osxdaily.com/2007/02/01/how-to-launch-gui-applications-from-the-terminal) command.  However when opening an 
application, you must give the absolute path name.  For example to open 
TextEdit.app you type this command:
<pre>
   open /Applications/TextEdit.app
</pre>
The [app](app) program is a front-end to the open command which automatically
searches for an application and finds the first match if an incomplete
portion of an application name is found (case insensitive).  Here is an 
equivalent command for opening TextEdit.app with the [app](app) program:
<pre>
   app text
</pre>

## Installation 

To install the program, copy to any directory in your command path
(<tt>/usr/bin</tt> always works, <tt>/usr/local/bin</tt> is better).
Run the terminal command:
<pre>
echo $PATH
</pre>
to see the list of directories in the command search path.  To copy to a
directory in that list:
<pre>
sudo cp app /usr/local/bin
</pre>

To verify that the [app](app) program is installed correctly type "which app"
which should replay with the location that to which copied the program:
<pre>
which app

/usr/local/bin/app
</pre>

If the program cannot be found, you may need to allow the computer to run
it as a program:
<pre>
sudo chmod 0755 /usr/local/bin/app
</pre>

You can also run the program from the current directory by prepending
the string "<tt>./</tt> to the command name:
<pre>
./app
</pre>

# Options

| Option	| Description						|
| ------------- | ----------------------------------------------------- |
| <tt>-f</tt>	|  display full paths of Applications. 		|
| <tt>-l</tt> 	|  list all Applications which are available 		|
| <tt>-w regexp</tt> 	|  list all Applications which string matches to.|
| <tt>-p</tt> 	|  display list in paragraph form. 			|
| <tt>-d</tt> 	|  deep search for apps					|

# EXAMPLES:

<dl>
   <dt>app</dt>
   <dd>Show a list of all Applications.</dd>
   <dt>app -l</dt>
   <dd>Same as "app" with no options.</dd>
   <dt>app string</dt>
   <dd>Run the first Application (sorted alphabetically) found which
      contains string.  Example: "app finder".</dd>
   <dt>app ^string</dt>
   <dd>Run the first Application found which starts with "string".</dd>
   <dt>app -f</dt>
   <dd>Show list of Applications, including full pathnames.</dd>
   <dt>app -w ^t</dt>
   <dd>Show a list of Applications which start with the letter T.</dd>
   <dt>app -p</dt>
   <dd>Show list of all Applications in paragraph form.</dd>
   <dt>app -d</dt>
   <dd>Search entire file structure for directories ending in ".app".</dd>
</dl>

## Main argument

When given only a single argument without options, the [app](app) command will
search for the first application which contains that string.  For example
typing the command:
<pre>
app text
</pre>
Will open <tt>/Applications/TextEdit.app</tt>.  If there are multiple
applications containing the string "text" and you want to open the
first one found which starts with that string, type:
<pre>
app ^text
</pre>
To type full application names with spaces, three methods are possible:
<pre>
app dvd\ player
app "dvd player"
app dvd_player
</pre>

## Listing all applications

Typing `app` by itself or `app -l` will alphabetically print a list of 
all applications found in the search path.

<pre>
app 

Activity Monitor
Adobe Flash Player Install Manager
AirPort Utility
App Store
AppleScript Editor
Audio MIDI Setup
Automator
Bluetooth File Exchange
Boot Camp Assistant
...
</pre>

The <tt>-f</tt> option causes the full pathname of the applications to
be shown in the listing.  The list is then sorted alphabetically including
the full path of the application.

<pre>
app -f

/Applications/App Store.app
/Applications/Automator.app
/Applications/Boxer.app
/Applications/Calculator.app
/Applications/Calendar.app
/Applications/Chess.app
/Applications/Contacts.app
/Applications/Dashboard.app
/Applications/Dictionary.app
...
</pre>

The <tt>-p</tt> option can be used to list the applications in paragraph
format.  This is useful for viewing larger numbers of applications in a
single window.  Spaces in the application name are converted to underscores
so that the start/stop of the application name is clear.

<pre> 
app -p

Activity_Monitor Adobe_Flash_Player_Install_Manager AirPort_Utility
App_Store AppleScript_Editor Audio_MIDI_Setup Automator
Bluetooth_File_Exchange Boot_Camp_Assistant Calculator Calendar
Chess ColorSync_Utility Console Contacts DVD_Player Dashboard
Dictionary DigitalColor_Meter Disk_Utility FaceTime Fetch Firefox
Font_Book GarageBand Google_Chrome Grab Image_Capture Inkscape
Keychain_Access Launchpad MacVim Mail Messages Mission_Control
Network_Utility Notes PDF_Converter_Free Photo_Booth Preview
QuickTime_Player QuickTime_Player_7 RAID_Utility RealPlayer
RealPlayer_Converter Reminders Remote_Desktop_Connection Safari
Stickies System_Information System_Preferences Terminal TextEdit
Time_Machine Toolkit VoiceOver_Utility X-COM_Demo XQuartz Xcode
iMovie iPhoto iTunes
</pre>

## List all applications matching a search pattern

By default the [app](app) command will open the first application that matches
to the argument.  The <tt>-w</tt option can be used to list all matches
to locate a secondary match.  The following example list all applications
which contain the string "te" (or "Te", "TE", "tE" since the case of the
text is ignored).

<pre>
app -w te

DigitalColor Meter
Game Center
Notes
PDF Converter Free
Remote Desktop Connection
System Information
System Preferences
Terminal
TextEdit
</pre>

To only search for matches at the start of a string prefix search with 
"<tt>^</tt>" (or "<tt>$</tt>" for the end of a string).

<pre> 
app -w ^te

Terminal
TextEdit
</pre>

## Deep searching

A variable at the top of the [app](app) program called <tt>@searchdirs</tt> 
contains a list of directories to search for applications.  The main
locations for applications in OS X is <tt>/Applications</tt> and
<tt>/Applications/Utilities</tt>.  The <tt>-d</tt> option can be used
to search for all applications on the computer in any location in the
directory structure.  The deep search uses the [locate](http://en.wikipedia.org/wiki/Locate_%28Unix%29) command.

When no argument is given, the <tt>-d</tt> will cause a list of all 
found applications to be listed.  For example the pre-defined search
path for applications may find about 100 applications:

<pre>
app | wc -l

85
</pre>

Doing a deep search will find many more:

<pre>
app -d | wc -l

468
</pre>

The <tt>-d</tt> option can be used to open an application not found
in the standard search path:

<pre>
app -d some_exotic_app
</pre>


