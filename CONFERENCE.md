    __     _____ ___ ____ _____ ____  _____ ____  _   _ ____  _     ___ ____ 
    \ \   / / _ \_ _/ ___| ____|  _ \| ____|  _ \| | | | __ )| |   |_ _/ ___|
     \ \ / / | | | | |   |  _| | |_) |  _| | |_) | | | |  _ \| |    | | |    
      \ V /| |_| | | |___| |___|  _ <| |___|  __/| |_| | |_) | |___ | | |___ 
       \_/  \___/___\____|_____|_| \_\_____|_|    \___/|____/|_____|___\____|
                                                                             
      ____ ___  _   _ _____ _____ ____  _____ _   _  ____ _____ 
     / ___/ _ \| \ | |  ___| ____|  _ \| ____| \ | |/ ___| ____|
    | |  | | | |  \| | |_  |  _| | |_) |  _| |  \| | |   |  _|  
    | |__| |_| | |\  |  _| | |___|  _ <| |___| |\  | |___| |___ 
     \____\___/|_| \_|_|   |_____|_| \_\_____|_| \_|\____|_____|
                                                                
     ____  _____ ___  _   _ ___ ____  _____ __  __ _____ _   _ _____ ____  
    |  _ \| ____/ _ \| | | |_ _|  _ \| ____|  \/  | ____| \ | |_   _/ ___| 
    | |_) |  _|| | | | | | || || |_) |  _| | |\/| |  _| |  \| | | | \___ \ 
    |  _ <| |__| |_| | |_| || ||  _ <| |___| |  | | |___| |\  | | |  ___) |
    |_| \_\_____\__\_\\___/|___|_| \_\_____|_|  |_|_____|_| \_| |_| |____/ 
                                                                       

VoiceRepublic Conference Requirements
=====================================

Data Import & Sync
------------------

* Text not longer than 2300 characters.
* Strings not longer than 140 characters.

### Fields

* URI (Unique Resource Identifier, technical requirement)
* Speaker Names (required for social media engagement)
* Speaker Emailadress (required for speaker engagement)
* Speaker Twitter Handle (required for social media engagement)
* ...

### Input Formats

* csv
* json
* xml


Technical Requirements
----------------------

### Setup

* A work space with a chair and a table with at least 80cm space for
  audio streaming equipment.

* Powerplug and Ethernet connector close by.

### Network

* Each audio stream may require up to 30 KB/s bandwidth.

* A stable Internet connection (via Ethernet) is key. Wifi has proven
  not to be reliable enough to garantee a stable streaming signal.

* Ports 443 (https), 9292 (https) and 1935 (rtmp) need to be open for
  incoming as well as outgoing traffic.

### Audio Signal

* XLR coming from the press split. Audio Jack has proven to deliver
  signals which are easily affected by disturbing signals.

### Contact

* Contact information (name, cell, email) of the person responsible
  for audio setup.

* Contact information (name, cell, email) of the person responsible
  for network setup.


VoiceRepublic Conference Features
---------------------------------

These options can be set per venue/series. The options have to be set
by a VR Backoffice Operator.

*TODO describe these features*

### Recommended Options

#### No Auto End Talk (no_auto_end_talk)

Talks on VR are ended automatically as soon as the sceduled time is
up. Keeping the scedule on conferences is tough. With this option set,
talks will not be ended automatically. For the talk to become
available in the archive, a stage operator will have to end the talk
manually.

#### No Email (no_email)

#### Loopback (loopback)
    
### Not Recommended Options

#### No Auto Processing (no_auto_postprocessing)

#### Suppress Chat (suppress_chat)


VR Conference Paper Form
------------------------

### General Information

* User ID (all Series/Talks will belong to on user)
* Sync frequency

### Defaults

* Price per Series
* Date of Completion
* Language

### Columns for List of Series and Talks

* Name
* Max. length
* synced/not editable (source?)
* not synced/editable (initial?)

### List of Fields in Series

* URI
* Title
* Teaser
* Description
* Tag list

### List of Fields in Talks

* URI
* Series
* Title
* Teaser
* Description
* Starts At
* Duration
* Language

