# Getting and Cleaning Data Course Project
This repository contains my final project for [Getting and Cleaning Data course](https://www.coursera.org/course/getdata)

The purpose of this project is to demonstrate an ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

## The raw data
The data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at [the site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) where the data was obtained. 

[Here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ) is an archive file with the raw data for the project.

## The script to prepare the tidy data set
The project contains `run_analysis.R` script. The script reads the raw data from a `UCI HAR Dataset` folder and produce `result.txt` file with the summary data in correspondence with principles of [tidy data](http://vita.had.co.nz/papers/tidy-data.pdf).
If script does not find `UCI HAR Dataset` directory in current working directory it would download the raw data from the internet.

## Transformations that were made to get the tidy data set from the raw data
`run_analysis.R` script makes following transformations on the raw data to get result file:
1. Combines the training and the test data sets in one.
2. Extracts only the measurements on the mean and standard diviation.
3. Adds column with activity names.
4. Adds column with subject number.
5. Aggregates above data set with the average of each variable for each activity and each subject.

[Here](CodeBook.md) is code book.
