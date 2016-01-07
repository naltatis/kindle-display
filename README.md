# Kindle Status Display

```
+----+  updates every X min   +--------+
|    |  ------------------>   |        |
|    |         wifi           |        |
|    |  <------------------   |        |
+----+      png greyscale     +--------+
hacked                           local
kindle                         webserver
```

## Setup

### Kindle

#### SSH Access
In order to install the scripts onto your kindle you need to get **root ssh access via usb**. The mobileread [forum](http://www.mobileread.com/forums/forumdisplay.php?f=150) and [wiki](http://wiki.mobileread.com/wiki/Kindle_Hacks_Information) are a great source on how to perform the **jailbreak**, install **usb networking** and **KUAL** for easiely enabling/disabling ssh access. So far we've only managed to make it work on the [Kindle 4](http://wiki.mobileread.com/wiki/Kindle_4).

#### Update Script

connect you Kindle via usb and ssh into it
```
ssh root@192.168.15.244
```

make the Kindle file system writable
```
mntroot rw
```

create the init and update scripts according to the files in the [kindle](https://github.com/naltatis/kindle-display/tree/master/kindle) directory.
```
vi /mnt/base-us/RUNME.sh
vi /mnt/base-us/display-weather.sh
```

add the update script to [/etc/crontab/root](https://github.com/naltatis/kindle-display/blob/master/kindle/etc/crontab/root)
```
*/30 5-22 * * * /mnt/us/display-weather.sh
```

execute the init script to disable all unneeded tasks and trigger an the first render
```
sh /mnt/base-us/RUNME.sh
```

### Server

The code in this repository is my personal setup which also pulls in data from the heating and ventilation system. Therefore I recommend **forking this repository** and modify the datasources and visual representation as you need it.

You need to have **node.js**/**npm**, **phantomjs** and **pngcrush** installed on the server machine. I'm using a RaspberryPI for this.

Clone the repository
```
git clone git@github.com:username/kindle-display.git kindle-display
cd kindle-display
```

Create your own config file. Adjust the list of plugins that should be used to provide data for the template. You can find the implementation in the `lib` directory.
```
cp config_sample.yaml config.yaml
vi config.yaml
```

Adjust template and styling. You probably want to delete much of my stuff here to get it to work.
```
vi views/index.jade
vi public/stylesheets/style.styl
```

Start the server and open your browser at [http://localhost:3000/](http://localhost:3000/)
```
npm start
```

Now you need to create a png file that can be served for the kindle.
```
./generate_png.sh
```

Now you should find a 600x800 grayscale png file in your `public` folder which is accessibale via [http://localhost:3000/weather_bw.png](http://localhost:3000/weather_bw.png).

Setup a cronjob that regularly executes the `generate_png` script.

## Plugins

...

## Todos

**Power Management:**
Right now the Kindle battery lasts for 2-3 days, depending on the refresh interval. I think here is room for improvement. There are a few options to change the Kindles power management settings, but we haven't found the perfect one yet.

## Credits

**Matthew Petroff**

  * [Blogpost: Kindle Weather Display](http://mpetroff.net/2012/09/kindle-weather-display/)
  * [Github: mpetroff/kindle-weather-display](https://github.com/mpetroff/kindle-weather-display)

**hahabird**

  * [Blogpost: Kindle Weather and Recycling Display](http://hackaday.com/2013/04/01/kindle-weather-and-recycling-display/)
  * [Imgur: Pictures of Wodden Frame](http://imgur.com/a/17Y89)