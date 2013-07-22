#!/usr/bin/env python
# -*- coding: utf-8 -*-
from psychopy import visual, core, event, gui
from datetime import datetime
import os

# parameters
rechner = "netbX"
folder = "data"

filePath = os.path.join(folder, rechner + ".dat")

#create a window to draw in
myWin = visual.Window((1024.0,600.0),allowGUI=True,winType='pyglet',
            monitor='testMonitor', units ='norm', screen=0, fullscr = False, color = "white")

#choose some fonts. If a list is provided, the first font found will be used.
FONT = ['Gill Sans MT', 'Arial','Helvetica','Verdana'] #use the first font found on this list


# objects for code
q1 = visual.TextStim(myWin, units='norm',height = 0.15, pos=(0, 0.5), text='Welches Dorf? Gelb (g) oder Violett (v)', font=FONT, color='black', wrapWidth = 1.7)
code = visual.TextStim(myWin, units='norm',height = 0.1, pos=(0, 0), text='', font=FONT, color='black')

# objects for rating scale:
ratingVio = visual.RatingScale(myWin, low = 1, high = 10, tickMarks = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], textColor = "black", lineColor = "black", markerColor = "#ff00ff", 
                   textSizeFactor = 2, stretchHoriz = 2, minTime = 0)
ratingYel = visual.RatingScale(myWin, low = 1, high = 10, tickMarks = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], textColor = "black", lineColor = "black", markerColor = "#ffff00",
                   textSizeFactor = 2, stretchHoriz = 2, minTime = 0)
question = u"Wie glücklich sind Sie gerade?"
ques2 = u"1 = Ich möchte sofort nach Hause gehen\n10 = Ich möchte für immer hier bleiben"
myItem = visual.TextStim(myWin, text=question, pos = (0, 0.5), height=.20, units='norm', wrapWidth = 2, color = "black", alignHoriz='center')
myItemInfo = visual.TextStim(myWin, text=ques2, height=.13, units='norm', wrapWidth = 1.5, color = "black", alignHoriz='center')

# everything runs in a loop
while True:
    # Loop for obtaining code (quits on escape)
    codeText = ""
    pressedEnter = False
    while not pressedEnter:
        code.setText(codeText)
        q1.draw()
        code.draw()
        myWin.flip()
        #keys = event.waitKeys(keyList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h", "j", "k", "l", "y", "x", "c", "v", "b", "n", "m", "backspace", "enter", "return", "escape"])
        keys = event.getKeys(keyList = ["g", "v", "escape"])
        #print(keys)
        if "backspace" in keys:
            if len(codeText) > 0:
                codeText = codeText[:-1]
            else:
                continue
        elif ("return" or "enter") in keys:
            pressedEnter = True
        elif "escape" in keys:
            core.quit()
        elif len(keys) > 0:
            codeText = keys[0]
            pressedEnter = True
    
    # loop for rating scale     
    event.clearEvents()
    if codeText == "g":
        myRatingScale = ratingYel
    elif codeText == "v":
        myRatingScale = ratingVio
    myRatingScale.reset()
    myRatingScale.setMarkerPos(4)
    pressedEnter = True
    rating = None
    while myRatingScale.noResponse: # show & update until a response has been made
        #while rating == None:
        myItem.draw()
        myItemInfo.draw()
        myRatingScale.draw()
        kRating = event.getKeys(keyList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
        if kRating == ["0"]:
            kRating = ["10"]
        #print(kRating)
        if not kRating == []:
            myRatingScale.setMarkerPos(int(kRating[0])-1)
        myWin.flip()
        
    rating = myRatingScale.getRating() # get the value indicated by the subject, 'None' if skipped 
    
    
    
    # write data
    if os.path.isdir(folder):
        outfile = open(filePath, 'a')
        outfile.write(codeText)
        outfile.write("\t")
        outfile.write(str(rating))
        outfile.write("\t")
        outfile.write(str(datetime.now()))
        outfile.write("\n")
        outfile.close()
    else:
        print "Couldn't write: Code: ", codeText, ', Zufriedenheit =', rating, " Aktuelle Zeit:", str(datetime.now())


    

