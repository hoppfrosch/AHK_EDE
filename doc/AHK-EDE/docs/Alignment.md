#Windows Alignment within EDE ![AHK_EDE](img/AHK_EDE.png)

![This page is still under construction](img/Under_construction.png)

***EDE*** offers a broad functionality ***to align your active window on the current monitor***. The alignment functionality is 
highly configurable and can be for example configured to mimic the Windows Aero-Snap functionality of using keys *WIN*+*LEFT* and *WIN*-*RIGHT* to move the window 
around the monitor (but: EDE-Windows alignment only moves around the current monitor).

Windows alignment comprises positioning as well as resizing the window.

As it's a quite complex feature, the general concept is described first.

## General Concept

- The windows aligment in ***EDE*** is accessible on TAB1 (Opened via ![Left-WIN](img/Keys/Key-Win.png) + ![NUMPAD-1](img/Keys/Key-1.png)) and subsequently pressing one of the NUMPAD-Keys ![NUMPAD-1](img/Keys/Key-1.png), ![NUMPAD-2](img/Keys/Key-2.png), ![NUMPAD-3](img/Keys/Key-3.png), ![NUMPAD-4](img/Keys/Key-4.png), ![NUMPAD-5](img/Keys/Key-5.png), ![NUMPAD-6](img/Keys/Key-6.png), ![NUMPAD-7](img/Keys/Key-7.png), ![NUMPAD-8](img/Keys/Key-8.png), ![NUMPAD-9](img/Keys/Key-9.png).

- The NUMPAD-Keys above could be considered as a compass. This could be used as a crib to memorize the aligment directions.

![Function panel](img/GUI/TAB1-functions.png)  <-> ![NUMPAD](img/GUI/NumPad.png) <-> ![Compass](img/Misc/Compass.png)
  
Direction-Key                   | Direction  | Description
--------------------------------|------------|---------------------------------------
![NUMPAD-1](img/Keys/Key-1.png) | South-West | Moves Window to the lower left corner of the current screen
![NUMPAD-2](img/Keys/Key-2.png) | South      | Moves Window to the lower border of the current screen
![NUMPAD-3](img/Keys/Key-3.png) | South-East | Moves Window to the lower right corner of the current screen
![NUMPAD-4](img/Keys/Key-4.png) | West       | Moves Window to the left border of the current screen
![NUMPAD-5](img/Keys/Key-5.png) | Center     | Moves Window to the center of the current screen
![NUMPAD-6](img/Keys/Key-6.png) | East       | Moves Window to the right border of the current screen
![NUMPAD-7](img/Keys/Key-7.png) | North-West | Moves Window to the upper left corner of the current screen
![NUMPAD-8](img/Keys/Key-8.png) | North      | Moves Window to the upper border of the current screen
![NUMPAD-9](img/Keys/Key-9.png) | North-East | Moves Window to the upper right corner of the current screen

- For each direction key several destination positions/sizes can be configured ("Position configurations)). 

- While TAB1 is active the direction-keys can be pressed repeatedly (either the same or a different direction key). This moves/resizes the current window on the current screen according to the associated position configuration. For example pressing direction-keys ![NUMPAD-1](img/Keys/Key-1.png)-![NUMPAD-1](img/Keys/Key-1.png) (while TAB1 is active) moves/resizes the window to the position/size defined in the second position configuration for this direction key. 

- Each direction key may have an endless number of position configurations - repeatedly pressing the direction key (while TAB1 is active) cycles through the direction keys position configurations (if the last position configuration is used the next movement will go to the first position configuration). 

- For documentation on configuration see [Configuration file](https://github.com/hoppfrosch/AHK_EDE/blob/master/EDE.xml)

