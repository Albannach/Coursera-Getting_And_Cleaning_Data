# Coursera Getting And Cleaning Data

## Load, Transform

The **run_analysis.R** script performs the following actions...

1. Load the data from the two provided descriptive file, **activity_labels.txt** and **features.txt**.
2. From the **features.txt** file, create a dataframe containing the names of those features. 
concerned with either a _mean_ measurement or a corresponding _standard deviation_.
3. Load the raw data files into a list of data tables.
4. Change the names of the columns in the raw tables which corresponded to the **Subject** or 
the **Activity** from the defualt **V1**.
5. Create and **id** column in each of the raw tables; this will be used for merging tables later in the processing. Create a **source** column in the **X_test** and **X_train** datasets in order to 
track the source of the rows if required.
6. Form a complete **test** and a complete **train** dataset by merging the relevant 'X', 'Y' and 'Subject' dataframes by the 'id' column created in step 5.
For example the **X_test.txt**, **Y_test.txt** and **Subject_test.txt** files were merged to create the **test** dataframe; similarly with the **train** raw data tables to create a **train**.
7. The column names for the derived data tables were formed and a data set **onlyMeanSTD** was created which held only those measurements related to the means or standard deviations.
8. The text description of the activities (from the **activity_labels.txt** file) e.g. 'STANDING', were then substituted for the codes in the raw data.
9. The column names in the **onlyMeanSTD** dataset were changed to reflect the description of the measurement held in the **features.txt** file.

The steps described above constituted the processing required to read and transform the data for analysis.

