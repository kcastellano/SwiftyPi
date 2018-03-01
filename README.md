# SwiftyPi
Repo that contains the App, Server and Embedded code for my try! Swift Tokyo presentation

# Setting up the RaspberryPi

If you want to set up the Raspberri Pi without using any Monitor, we can do it on a Headless Mode:

- Download Ubuntu from [Ubuntu Pi Flavor Maker](https://ubuntu-pi-flavour-maker.org/download/) on our Mac.
- Flash an SD Card (32GB) with the Ubuntu Operative System using [Etcher](https://etcher.io)

## Mac and Pi connection

Before we insert our SD Card, we need to give our Pi access to the Internet. To do so, here are the following steps:

- Connect your Mac and your Pi with an Ethernet Cable.
- Go to System Preferences -> Sharing -> Select the ethernet connection and turn on Internet Sharing.

## Accessing your Pi

-  List all the active networks using  ```ifconfig```
- Check the IP on the bridge connection.
- Map out the network using ``` nmap -n -sP 192.168.NumberOfBridge.255/24 ```
- Copy the second IP from the list and do ``` ssh ubuntu@second-ip-from-nmap```
- Introduce user ```ubuntu``` and password  ```ubuntu``` and once logged in change the password.

## Setting up Swift

- Download the Swift 3.1.1 binaries by using [Swift Version Manager](https://github.com/kylef/swiftenv) or through the [Swift Build on ARM repo from @uraimo] (https://github.com/uraimo/buildSwiftOnARM)
- Check the Swift version using ```swift --version```

## Creating a Project

- Create a folder with ```mkdir TestProject```
- Go into the folder and then do ```swift package init —type executable```
- Or if you prefer you can build an XCode project with ```swift package generate-xcodeproj```
- Build and run using ```swift run```


## Adding your Swift files

- Use **netatalk** to be able to access the Pi’s folder system. 
- Use on the Mac ```open afp://ip-address-of-pi```

