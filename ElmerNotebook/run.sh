#!/bin/bash

MPI=true

mkdir -p Log
echo "Removing old log files:"
rm -v ./Log/*

# add a log file
echo "New log file handling:"
if [ "$#" == "0" ]
then
	echo "No log generated. To get a log file, run: ./main.sh log_name" | tee $LOGFILE
	logname=""
else
	echo "Log file name set to $1. It is stored in ./Log folder" | tee $LOGFILE
	logname="$1-"
fi

DATE=$(date +%s)
LOGFILE="./Log/$logname$DATE.log"

echo " "
echo "*** ELMERSOLVER ***"
echo "*** Cleaning past results" | tee $LOGFILE
rm -v "./RESU/case*"| tee -a $LOGFILE
echo "*** Run the coil powering: coil-energization.sif" | tee $LOGFILE

if [ $MPI == true ]
then
	ElmerGrid 2 2 MESH -metis 4 3 -partdual
	mpirun -np 4 ElmerSolver_mpi "case.sif" | tee -a $LOGFILE
else
	ElmerSolver "case.sif" | tee -a $LOGFILE
fi
