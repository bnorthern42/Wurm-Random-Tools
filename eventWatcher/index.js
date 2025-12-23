const conf = require("./conf.js");
const fs = require("fs");
//get current month and year
const currYear = new Date().getFullYear();
let currMon = new Date().getMonth();
if(curMon < 10)
	currMon="0"+currMon;// add 0 to front
const player=conf.playername;

const eventfile=conf.configLocation+"/players/"+player+"/logs/_event."+currYear"-"+currMon+".txt"

fs.watchFile(eventfile)
