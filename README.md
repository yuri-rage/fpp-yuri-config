## Falcon Player configuration by Yuri

Using Falcon Player on an RPi4 with two wifi interfaces on separate networks

#### Background:
I wanted to use an RPi4 with two wifi interfaces to control xLights sequences with Falcon Player.  I wanted one interface to connect to my home wifi network for easy web-interface control from my laptop or smartphone (or possibly home automation), with the other interface dedicated to a separate network to avoid saturating my home network with E.131 packets.

However, the default configuration of wpa_supplicant + ConnMan make that rather difficult. ConnMan is great for simple wifi connectivity.  Adding a second interface seems quite problematic, and I never had any success getting ConnMan to automatically connect the second interface.  So, I opted to leave Falcon Player's wifi connection scheme completely blank and script some iwd/iwctl commands to "force" the issue to my liking.

I also wanted to enable Bluetooth audio output, but that proved more difficult than I expected, and I probably won't spend any more time on it.  I've settled for a Creative Labs USB sound card with wired output to an FM transmitter (well documented elsewhere).

The following steps should be executed via the command line (I used an ssh shell).  This will likely work best on a new/clean install of Falcon Player.

Fair warning...if you aren't somewhat familiar with the Linux command line, this may prove slightly difficult.

#### Step 1: Install iwd
`sudo apt-get install iwd`

#### Step 2: Uninstall wpa_supplicant to avoid conflicts
ConnMan is still required by Falcon Player, and it will use iwd by default if wpa_supplicant is not found.  I just let Falcon Player run its ConnMan scripts as usual but then force my own connection scheme using the script and cron job (as outlined in the remaining steps).  As of v4.x, this works for me.

`sudo apt-get purge wpa_supplicant`

#### Step 3: Use iwctl to connect to your networks
This step creates profiles that "remember" network keys/passwords for future auto-connection
TODO

#### Step 4: Install my force-wifi script
First edit the script to include your network SSIDs (lines 3 and 4 of the script).

    cd ~
    wget https://raw.githubusercontent.com/yuri-rage/fpp-yuri-config/main/force-wifi.sh
    nano force-wifi.sh # edit the SSIDs here
    sudo cp force-wifi.sh /usr/local/bin
    sudo chmod 755 /usr/local/bin/force-wifi.sh
    
#### Step 5: Add a cron job to periodically ensure that both wifi interfaces are connected the way I want
TODO
