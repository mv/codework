import sys
import os
import string

class WorkTime:
    def __init__(self):
        self.days = 0
        self.mins = 0
        
    def processFile(self, fileName):
        src = file(fileName)
        for line in src:
            if line[0] != "#":
                self.processLine(line.strip())

    def processLine(self, line): 
        self.days += 1
        times = [int(h)*60 + int(m) for h, m in [t.split(":") for t in map(string.strip, line.split(";"))]]
        for init, end in [(times[i], times[i+1]) for i in range(0, len( times ), 2)]:
            self.mins += end-init

    def showReport(self):
        print "Worked %d days - %s hours" % (self.days, self.toHour(self.mins))
        daysMins = self.days*8*60
        if daysMins > self.mins:
            print "  WORK MORE!! - debit of %s hours" % self.toHour(daysMins - self.mins)
        if daysMins < self.mins:
            print "  GO HOME!! - credit of %s hours" % self.toHour(self.mins - daysMins)

    def toHour(self, mins):
        return "%02d:%02d" % divmod(mins, 60)
        
if __name__ == "__main__":
    fileName = sys.argv[1]

    work = WorkTime()
    work.processFile(fileName)
    work.showReport()
    