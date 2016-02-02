#!/usr/bin/python

from Bio import SeqIO
import sys

readDict = dict()

with open(sys.argv[1],"rb") as r1:
	for record in SeqIO.parse(r1,'fastq'):
		if record.id in readDict:
			readDict[record.id]["r2"] = record.format("fastq")
		else:
			readDict[record.id] = dict()
			readDict[record.id]["r1"] = record.format("fastq")
			readDict[record.id]["r2"] = None

with open(sys.argv[2]+".r1.fastq","w") as pe1, open(sys.argv[2]+".r2.fastq","w") as pe2, open(sys.argv[2]+".se.fastq","w") as se:
	for key in readDict:
		if readDict[key]["r1"] == None:
			se.write(readDict[key]["r2"])
		elif readDict[key]["r2"] == None:
			se.write(readDict[key]["r1"])
		else:
			pe1.write(readDict[key]["r1"])
			pe2.write(readDict[key]["r2"])

