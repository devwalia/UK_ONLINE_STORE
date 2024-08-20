/**********************************************************************************/
/* Solutions to Final Project by Dev Walia */
/**********************************************************************************/
LIBNAME s40840 '/home/u63898820/Dev';

/* Title text using the proc odstext sections below */
title1 c=stb  bcolor=lightblue height=24pt "Data Programming with SAS Final Project";
title2 " ";
title3 c=stb bcolor=lightblue height=16pt "Dev Walia";
title4 c=stb bcolor=lightblue height=16pt "Student No. 23205184";
title5 " ";
options nodate;


/**********************************************************************************/
/*------------------Task 1: Data Analysis (I am using online UK retail store dataset) --------------------------*/
/**********************************************************************************/

/* Importing the dataset from a CSV file (Change the file location, I have attached the file) */
proc import datafile="/home/u63898820/sasuser.v94/datasets/Online_Retail.csv"
    out=work.OnlineRetail
    dbms=csv
    replace;
run;

/* Displaying the first few rows to understand the dataset's structure */
title6 c=stb bcolor=lightblue Height=14pt "Data Analysis I: Import and Preview Online UK Retail Data";
proc print data=work.OnlineRetail(obs=10);
run;
title;
proc odstext;
P "The CSV file has been read in successfully using a PROC import step for Data Analysis 1. Printing the first few rows to confirm this."

/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

/* Detailed structure and types of data, which helps in deciding further data handling steps */
title1 c=stb bcolor=lightblue Height=14pt "Detailed structure and Types of Data ";
proc contents data=work.OnlineRetail;
run;
title;
proc odstext;
P "The dataset includes categorical variables like InvoiceNo, StockCode, Description, CustomerID, and Country, along with numerical variables such as Quantity, InvoiceDate, and UnitPrice, which capture transaction details and product information in an online retail context."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Providing summary statistics for all numerical variables */
title1 c=stb bcolor=lightblue Height=14pt "Summary statistics for all numerical variables";
proc means data=work.OnlineRetail N mean std min p25 median p75 max;
    var Quantity UnitPrice;
run;
title;
proc odstext;
P "The statistical summary reveals substantial variability in `Quantity` and `UnitPrice` with extremes suggesting data quality issues, including negative values. Most transactions involve small quantities and lower-priced items, with the data showing a skewed distribution towards a few high-value transactions. This suggests a need for data cleaning and potential adjustments in inventory and pricing strategies."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Removing records with cancellations, negative quantities, 'Adjust bad debt', and duplicates to ensure data quality */
data work.CleanRetail;
    set work.OnlineRetail;
    if substr(InvoiceNo, 1, 1) ne 'C' and Quantity > 0 and Description ne 'Adjust bad debt';
run;

/* Sort data and remove duplicates */
proc sort data=work.CleanRetail nodupkey out=work.CleanRetail;
    by InvoiceNo StockCode Description CustomerID InvoiceDate;
run;

/* Calculating Total Revenue for each transaction */
data work.CleanRetail;
    set work.CleanRetail;
    TotalRevenue = Quantity * UnitPrice;
    format TotalRevenue dollar8.2;
run;

/* Checking for missing Customer IDs and assigning temporary IDs if necessary */
data work.CleanRetail;
    set work.CleanRetail;
    if missing(CustomerID) then NewCustomerID = compress('TEMP' || InvoiceNo);
    else NewCustomerID = CustomerID;
run;

/* Preview of Cleaned and Processed Retail Data */
title1 c=stb bcolor=lightblue Height=14pt "Preview of Cleaned and Processed Retail Data";
proc print data=work.CleanRetail(obs=5);
run;
title;
proc odstext;
P "The processed dataset now reflects transactions from active sales, with data cleansing eliminating cancellations and data errors, ensuring each record is from a unique transaction with valid quantities and prices, resulting in a consistent dataset ready for further analysis."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

/* Providing summary statistics for all numerical variables */
title1 c=stb bcolor=lightblue Height=14pt "Summary Statistics for Quantity, UnitPrice, and TotalRevenue";
proc means data=work.CleanRetail N mean std min p25 median p75 max;
    var Quantity UnitPrice TotalRevenue;
run;
title;
proc odstext;
P "Summary statistics reveal a mean quantity of approximately 11 per transaction with significant variability, and a moderate average unit price of about 3.89 sterling, reflecting typical retail conditions. Total revenue per transaction averages around 20.31, with values ranging up to nearly 168,650, indicating occasional high-value purchases."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Frequency distribution of Country to see the data spread across countries */
title1 c=stb bcolor=lightblue Height=14pt "Frequency Distribution of Countries in Data";
proc freq data=work.CleanRetail;
    tables Country / nocum nopercent norow nocol;
run;
title;
proc odstext;
P "The frequency distribution analysis of the dataset confirms that the majority of transactions are concentrated in six primary countries: United Kingdom, Germany, France, EIRE, Spain, and the Netherlands."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Filtering data for top six countries */
data work.TopCountries;
    set work.CleanRetail;
    if country in ('United Kingdom', 'Germany', 'France', 'EIRE', 'Spain', 'Netherlands');
run;

/* Box plot for Unit Price by Country to explore pricing differences across top six countries */
title1 c=stb bcolor=lightblue Height=14pt "Unit Price Distribution by Top Six Countries";
proc sgplot data=work.TopCountries;
    vbox UnitPrice / category=Country;
    xaxis label='Country';
    yaxis label='Unit Price';
run;
title;
proc odstext;
P "The box plot illustrates that while most countries have similar unit price distributions with few outliers, the United Kingdom exhibits significantly more variation with several high outliers, indicating occasional very high-priced items."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Histogram of Total Revenue to visualize the distribution of transaction values */
title1 c=stb bcolor=lightblue Height=14pt "Distribution of Total Revenue";
proc sgplot data=work.CleanRetail;
    histogram TotalRevenue / scale=count binstart=0 binwidth=20;
    xaxis label='Total Revenue' min=0 max=100; /* Adjusting the x-axis range to focus on common revenue ranges */
    yaxis label='Frequency';
run;
title;
proc odstext;
P "The histogram of Total Revenue shows a heavily right-skewed distribution with most transactions generating less than $20, indicating that lower-priced purchases dominate this retail data set. A significant drop in frequency beyond the $20 mark suggests fewer high-value transactions."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Scatter Plot for Unit Price vs Total Revenue */
title1 c=stb bcolor=lightblue Height=14pt "Scatter Plot of Total Revenue vs. Unit Price";
proc sgplot data=work.CleanRetail;
    scatter x=UnitPrice y=TotalRevenue;
    xaxis label='Unit Price';
    yaxis label='Total Revenue';
run;
title;
proc odstext;
P "The scatter plot reveals that most transactions involve low unit prices and generate modest total revenues, with a few outlier transactions showing exceptionally high total revenues at moderate unit prices, suggesting bulk purchases or high-value sales."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


proc odstext;
P "The End For Data Analysis I, I selected the Online UK Retail dataset which includes both categorical and numerical variables such as InvoiceNo, StockCode, Description (categorical), and Quantity, InvoiceDate, UnitPrice (numerical). Using SAS, I successfully imported the data, displayed its structure, and provided descriptive statistics highlighting substantial variability in 'Quantity' and 'UnitPrice'. Further data cleaning processed transactions by removing cancellations and data errors to ensure integrity. I utilized graphical summaries to showcase distributions and relationships, like the histogram of total revenue and box plots for unit prices by country, reflecting the dominant low-value transactions and variation in pricing. This comprehensive analysis utilized SAS functionalities effectively to illustrate the retail dataset's characteristics and dynamics."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};



/**********************************************************************************/
/*------------------Task 2: University Data Analysis --------------------------*/
/**********************************************************************************/

/* Importing the dataset from a CSV file */
proc import datafile="/home/u63898820/my_shared_file_links/u63819461/datasets/universities.csv"
    out=work.university
    dbms=csv
    replace;
run;

/* Displaying the first 5 observations and the first 5 variables */
title1 c=stb bcolor=lightblue Height=14pt "Data Analysis II: Q1.a. Preview of University Data: First 5 Observations";
proc print data=work.university(obs=5);
    var university_name year world_rank country national_rank;
run;
title;
proc odstext;
P "A1.a. Successfully imported university data includes key variables like university name, year, world ranking, country, and national ranking, providing a snapshot of the data's structure for analysis."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

/* Use proc contents to display variable information, sorted by creation order */
title1 c=stb bcolor=lightblue Height=14pt "Q1. b.Variable Information and Order";
proc contents data=work.university order=varnum;
    ods select position;
run;
title;
proc odstext;
P "A1.b. Displayed here is a sorted list of the variables from the 'university' dataset, detailing attributes such as name, type, and format, which are essential for subsequent data handling and analysis."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

/* Descriptive statistics for student/staff ratio */
title1 c=stb bcolor=lightblue Height=14pt "Q2. Descriptive Statistics for Student/Staff Ratio";
proc means data=work.university N mean median min max std maxdec= 2;
    var student_staff_ratio;
run;
title;
proc odstext;
P "A2. The mean of the student/staff ratio is 15.99."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

/* Univariate analysis of the number of students */
title1 c=stb bcolor=lightblue Height=14pt "Q3. Univariate Analysis: Number of Students";

/* Univariate analysis of the number of students */
proc univariate data=work.university;
    var num_students; /* Correct variable name used */
    histogram num_students / normal;
    inset mean std / header = 'Summary Statistics';
run;


proc odstext;
P "A3.The univariate analysis for the variable number of students across 543 observations reveals a mean of approximately 24,504, a median of 22,578, and a mode of 2,243 students (the most frequently occurring value, present in only four instances, suggesting multiple modes). The data exhibits significant variability with a standard deviation of about 14,091, a variance of 198,566,122, and a range of 118,743 (between 2,243 and 120,986 students). The interquartile range is 15,554, indicating that the middle 50% of data points are spread across a relatively wide range. The distribution's skewness of 1.73 and a kurtosis of 5.917 suggest a right-skewed and peakier distribution compared to a normal distribution, which is further confirmed by goodness-of-fit tests indicating poor fit to a normal model. These statistical indicators highlight a diverse dataset with a significant spread and multiple peaks in the distribution of the number of students."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

/* Correlation analysis among various measures */
title1 c=stb bcolor=lightblue Height=14pt "Q4. Correlation Analysis Among Measures";
proc corr data=work.university nosimple noprob;
    var score award pub teaching; 
run;
title;
proc odstext;
P "A4. Correlation analysis explores relationships between university scores, awards, publications, and teaching quality, Yes these correlations statistically significant different from Zero (less than 1 & equal to 1)."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

/* Hypothesis testing for difference in student numbers between USA and UK */
title1 c=stb bcolor=lightblue Height=14pt "Q5. Hypothesis Testing: USA vs UK Universities";
data work.usa_uk;
    set work.university;
    if upcase(country) in ('USA', 'UNITED KINGDOM');
run;


/* T-Test for equality of means */
proc ttest data=work.usa_uk alpha=0.01 plots=all;;
    class country;
    var num_students; 
run;
title;
proc odstext;
p "A5. Null Hypothesis (H0): No significant difference in mean student numbers between USA and UK universities.  Assumptions Checked: Normality via Q-Q plots; variance equality rejected, leading to Satterthwaite's approximation for t-tests.  T-Test Result: Significant at α = 0.01 with a p-value of 0.0063, indicating a statistical difference in student numbers, favoring higher numbers in USA universities.  Distribution Analysis: USA shows a broader range with more outliers compared to the UK, supported by histograms and box plots.  Conclusion: Statistical analysis supports a significant difference in student populations, with implications for educational policies and resource allocation between the two countries."
/ style={font_size= 12pt font_face='Helvetica' leftmargin=0.75in rightmargin=0.25in just=l};
run;


/* Creating a subset for universities in the UK, Germany, and Italy */
data work.uni1;
    set work.university;
    if country in ('United Kingdom', 'Germany', 'Italy');
run;

/* Analysis of top universities in selected countries */
title1 c=stb bcolor=lightblue Height=14pt "A6. Analysis of Top Universities in Selected Countries";
proc print data=work.uni1(firstobs=10 obs=17);
    var university_name year world_rank country national_rank; 
run;
title;
proc odstext;
P "Sapienza University of Rome Italian university is the highest ranked"
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Mean quality of education overall and for scores > 100 */
title1 c=stb bcolor=lightblue Height=14pt "A7.Mean quality of education overall and for scores > 100 ";


proc means data=work.uni1 mean;
    var quality_of_education; /* Adjust variable name as necessary */
run;

proc means data=work.uni1 mean;
    var quality_of_education; /* Adjust variable name as necessary */
    where quality_of_education > 100;
run;


proc odstext;
P "The average quality of education across the entire uni1 dataset is 213.55, while for the subset where the quality score exceeds 100, it stands at 266.366."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};



/* Grouped summary statistics for patents */
title1 c=stb bcolor=lightblue Height=14pt "Q8. Grouped Summary Statistics for Patents";
proc means data=work.uni1;
    class country;
    var patents;
    output out=work.patents_summary;
run;
title;
proc odstext;
P "A8. The table presents grouped summary statistics for patents across universities in Germany, Italy, and the United Kingdom. Italy shows the highest average number of patents per university (532.21), suggesting a strong focus on innovation and research, while the UK, despite having the most observations, exhibits the lowest average (305.84). The standard deviation indicates significant variability in the number of patents across universities in each country, reflecting differences in research output and capabilities."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};
proc odstext;
p "Q9. A plot of the publications variable by country"
/ style={fontweight=bold font_size= 16pt font_face='Helvetica' leftmargin=.75in rightmargin=.25in just=left};
run;
/* Histogram of publications by country */
title1 c=stb bcolor=lightblue Height=14pt "Histograms of Publications by Country";

proc sgpanel data=uni1;
    panelby country / columns=1 layout=rowlattice;
    histogram pub;
    colaxis label="Number of Publications";
    rowaxis label="Frequency";
run;

title;
proc odstext;
P "A9. The histograms depicting the distribution of publications across universities in Germany, Italy, and the United Kingdom reveal distinct patterns in each country. German universities show a relatively uniform distribution, mostly clustering between 30 and 50 publications, indicating consistent output. In contrast, Italian universities exhibit a bimodal distribution with notable peaks around 30 and 50 publications, reflecting a more varied publication count. The UK shows the greatest variability, with a primary peak at 30 publications but extending up to 70, suggesting a broader range of publication activity among its universities. These observations indicate that German universities maintain a steady publication rate, Italian institutions vary more broadly, and UK universities display the most diverse range of publication outputs."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};



/**********************************************************************************/
/*------------------Task 3: Tasks demonstration (I will be reporting PCA Task) --------------------------*/
/**********************************************************************************/

title1 c=stb bcolor=lightblue Height=14pt "Task Demonstration: Principal Component Analysis ->PCA is a statistical technique used to emphasize variation and bring out strong patterns in a dataset. It's often used to reduce the dimensions of the data by transforming it into a new set of variables, the principal components, which are uncorrelated and which maximize the variance. This analysis helps in understanding the data structure, detecting outliers, and performing feature reduction for other machine learning tasks.";
/* Load the SASHELP.IRIS dataset */
proc print data=sashelp.iris(obs=5);
run;
title;
proc odstext;
P "We using inbuilt iris datset to perform the task PCA"
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

/* Perform Principal Component Analysis */
title1 c=stb bcolor=lightblue Height=14pt "Performing PCA: The method involves loading the dataset, performing PCA, and then visualizing the results to interpret the principal components.";
proc princomp data=sashelp.iris out=Work.PcaOut;
	var SepalLength SepalWidth PetalLength PetalWidth;
run;
title;
proc odstext;
P "Purpose: Conducts PCA on the iris dataset considering all four primary measurements. The output dataset Work.PcaOut contains the principal components."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

proc odstext;
P "Findings after performing PCA on Iris Dataset: The Principal Component Analysis (PCA) of the Iris dataset reveals that the first principal component explains approximately 72.96% of the variance, indicating a strong pattern across the four measurements, while the first two components together account for about 95.81% of the variance. This suggests that most information about the Iris flowers can be captured in just two dimensions, which simplifies visualization and analysis. The plot of the first two principal components shows distinct clustering by species, particularly Setosa, which is well-separated from Versicolor and Virginica, demonstrating PCA's effectiveness in reducing dimensionality while preserving significant classification information."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Print the Eigenvalues to understand the variance explained by each principal component */
title1 c=stb bcolor=lightblue Height=14pt "Displaying PCA Output:";
proc print data=Work.PcaOut(obs=5);
	var Prin1 Prin2 Prin3 Prin4;
run;
title;
proc odstext;
P "Purpose: Displays the first five observations from the PCA output, showing the principal components for the first few data points, which helps in understanding the immediate transformation results."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Plot the first two principal components */
title1 c=stb bcolor=lightblue Height=14pt "Plotting First two Principal Components:";
proc sgplot data=Work.PcaOut;
	scatter x=Prin1 y=Prin2 / group=Species;
	xaxis label="Principal Component 1";
	yaxis label="Principal Component 2";
run;
title;
proc odstext;
P "Purpose: Visualizes the first two principal components, providing a scatter plot to evaluate how well PCA separated different species based on their transformed features. This is an excellent way to visually assess the effectiveness of PCA."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


proc odstext;
P "Conclusion: This report demonstrates how PCA can be utilized to reduce dimensionality and uncover patterns in multivariate data. The principal components provide a way to visualize complex data structures, helping in easier interpretation and analysis."
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Clean up intermediate datasets */
proc datasets lib=work nolist;
	delete PcaOut;
run;


/**********************************************************************************/
/*------------------The End!! Thank you for this Module. --------------------------*/
/**********************************************************************************/
