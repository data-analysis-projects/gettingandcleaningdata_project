# Getting and cleaning data course project README file

In this README file I will try to document the different steps I took to produce a tidy dataset 
from the different files of the Human Activity Recognition Using Smartphones Dataset by Reyes-Ortiz
et al. hosted at UCI Machine Learning Repository.

I tend to check if my code produces the correct output frequently using R commands like str() and dim().
This commands could have been omited from the final code, but I have decided to keep them because I 
think I would help during the merging of the different dataset in the first stages of the data cleaning
process.


### The data: The Human Activity Recognition Using Smartphones Dataset

The UCI HAR dataset is composed of two data folders from the different measures performed in the experiment
labeled test and train. This data arrangement is pointed out in the project README file where it mentions that:
"the obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for
generating the training data and 30% the test data". Each of this data folders contains three text data files 
plus  a inertial signals data folder. The UCI HAR dataset also contains three additional files: a data 
file that contains information about the labels of the different activities measured in the experiment
(activity_labels.txt), a data file of the name of the features (features.txt) and two files that provide 
information about how the experiment was conducted (features_info.txt and README.txt).

Information about the content of each of this files is included in the README.txt files under "The dataset includes
the following files". I won't reproduce this information but I point the reader to this source for further 
clarifications.

The Inertial Signals data folder will not be taken into account in the data cleaning process as the 
project specifications don't require the use of this data to produce the final measurements included in the 
final tidy dataset.


### Reading the data into R

The three data files from the test folder are read into R using read.table() function with the usual parameters
from the local working directory into three different data frames x\_test, y\_test and subject\_test

The three data files from the train folder are read into R using read.table() function with the usual parameters
from the local working directory into three different data frames x\_train, y\_train and subject\_train.

The data file with the labels of the different features (features.txt) is also read into R using read.table() 
function with the usual parameters from the local working directory into the features data frame.

The dimensions and basic information about the different data frames is checked using both the dim() and the str()
functions.


### Labeling the different data frames with features.txt labels

The vector of labels of the V2 from the features.txt is used to label the x\_train and x\_test data frames assigning
with the names() function the names of the variables of this two data frames to those of this V2 variable.

Both subject\_train and subject_test data frames variable names are assigned to "subject" using also the names() function.


### Merging the different data frames

We have previously checked the dimensions of the different data frames in the first step of the data cleaning process.
This information is crucial to merge correctly the different data frames.

In a first step, two different data frames are created using the cbind() function. A train data frame, merging the data frames column wise, using the x\_train, y\_train and subject\_train data frames, including all the training data and a test data frame, merging the data frames column wise, using the x\_test, y\_test and subject_test data frames, including all the test data.

In a second step, this two data frames (train and test) are merged together row wise into the data data frame 
putting the test data frame observations at the end of the train observation using the rbind() function.

During the merging process the dimensions of the resulting intermediate and final data frames are constantly checked using the dim() and str() functions to ensure that the process is done correctly.


### Extracting the mean and standard deviation measurements for each measurement 

The next step in the data cleaning process is to select only the mean and the standard deviation measurement for each measurement from the data data frame. I used the grep() function passing the regular expression "mean|std" and I applied it to select only variable names that contain the strings "mean" or "std" from the data data frame. I omited the last variables in the data frame that correspond to the angle measurements as I thought only the information related to the body measurements, both non transformed and the fast fourier transformed of this body measurements, were relevant to the problem in hand. The result of the grep() function was stored in the subsetnames vector. 

I included in the subsetnames vector the names of both the subject and activity variables that were not included using by grep() function using the regular expression previously mentioned.

I finally subset the data data frame using the subsetnames vector to create a new data frame data2.


### Labeling the activity names variable to descriptive activity names

In order to use descriptive activity names to name the activities in the data set, I converted the activity variable into a factor variable factors using the factor() function. I set the labels of this factor variables to be those in the vector of names from the activity_labels.txt from the UCI HAR dataset, making some minor changes in those to meet R variable names common practices such as converting all to lowercase and getting rid of underscores. Then I assigned this factors variable to data2 activity variables changing each factor to its activity name.


### Cleaning and labeling correctly the data set descriptive variable names

I performed different gsub() commands to clean and label correctly the data set descriptive variable names. I changed the t and f in the beginning of the variable names to Time and FFT (Fast Fourier Transform), change the final hyphen to an underscore to divide the description of the variable to the different measurement, both "mean" and "std" for standard deviation, remove all the other parenthesis and underscores, and give relevant variable names to the abbreviation of the measurements ("Acceleration", "Gyroscope", "Magnitude") and finally remove some variable naming error, such as the changing "BodyBody" to only "Body" in some variable names.

All this changes were stored in the varnames vector. Finally, I assigned the varnames vector to the data2 variable names using the names() function and checked these changes using both the names() and str() functions.


### Creation of a new tidy data set with the average of each variable for each activity and each subject

The final step of the data cleaning process was the creation of a new tidy data set with the average of each variable for each activity and each subject. In order to create the tidy data set, I applied the aggregate() function passing all the variable as inputs and aggregating them based on the subject and activity variables using the mean function as aggregation function.

I think this final data set meets the specifications of a wide tidy data set described in the post "Long Data, Wide Data, and Tidy Data for the Assignment" (https://class.coursera.org/getdata-006/forum/thread?thread_id=236) in the course forums by David Hood.

As final step, I created the getDataProject.txt file from the tidy data frame using write.table with row.names=FALSE as parameter.