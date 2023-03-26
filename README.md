# INTRODUCTION
## What Is SQL? 
SQL is a widely used programming language that allows you to define and query databases. Whether you’re a marketing analyst, a journalist, or a researcher mapping neurons in the brain of a fruit fly, you’ll benefit from using SQL to manage database objects as well as create, modify, explore, and summarize data.

# About this book
Practical SQL starts with the basics of databases, queries, tables, and data that are common to SQL across many database systems. Chapters 13 to 17 cover topics more specific to PostgreSQL, such as full text search and GIS. The following table of contents provides more detail about the topics discussed in each chapter:
- Chapter 1: Creating Your First Database and Table introduces PostgreSQL, the pgAdmin user interface, and the code for loading a simple data set about teachers into a new database. 
- Chapter 2: Beginning Data Exploration with SELECT explores basic SQL query syntax, including how to sort and filter data. 
- Chapter 3: Understanding Data Types explains the definitions for setting columns in a table to hold specific types of data, from text to dates to various forms of numbers. 
- [Chapter 4: Importing and Exporting Data](./ch04.import-export-data/README.md) explains how to use SQL commands to load data from external files and then export it. You’ll load a table of U.S. Census population data that you’ll use throughout the book. 
- Chapter 5: Basic Math and Stats with SQL covers arithmetic operations and introduces aggregate functions for finding sums, averages, and medians. 
- Chapter 6: Joining Tables in a Relational Database explains how to query multiple, related tables by joining them on key columns. You’ll learn how and when to use different types of joins.
- Chapter 7: Table Design that Works for You covers how to set up tables to improve the organization and integrity of your data as well as how to speed up queries using indexes. 
- Chapter 8: Extracting Information by Grouping and Summarizing explains how to use aggregate functions to find trends in U.S. library use based on annual surveys. 
- Chapter 9: Inspecting and Modifying Data explores how to find and fix incomplete or inaccurate data using a collection of records about meat, egg, and poultry producers as an example. 
- Chapter 10: Statistical Functions in SQL introduces correlation, regression, and ranking functions in SQL to help you derive more meaning from data sets. 
- Chapter 11: Working with Dates and Times explains how to create, manipulate, and query dates and times in your database, including working with time zones, using data on New York City taxi trips and Amtrak train schedules. 
- Chapter 12: Advanced Query Techniques explains how to use more complex SQL operations, such as subqueries and cross tabulations, and the CASE statement to reclassify values in a data set on temperature readings. 
- Chapter 13: Mining Text to Find Meaningful Data covers how to use PostgreSQL’s full text search engine and regular expressions to extract data from unstructured text, using a collection of speeches by U.S. presidents as an example. 
- Chapter 14: Analyzing Spatial Data with PostGIS introduces data types and queries related to spatial objects, which will let you analyze geographical features like states, roads, and rivers. 
- Chapter 15: Saving Time with Views, Functions, and Triggers explains how to automate database tasks so you can avoid repeating routine work.
- Chapter 16: Using PostgreSQL from the Command Line covers how to use text commands at your computer’s command prompt to connect to your database and run queries. 
- Chapter 17: Maintaining Your Database provides tips and procedures for tracking the size of your database, customizing settings, and backing up data. 
- Chapter 18: Identifying and Telling the Story Behind Your Data provides guidelines for generating ideas for analysis, vetting data, drawing sound conclusions, and presenting your findings clearly. 
- Appendix: Additional PostgreSQL Resources lists software and documentation to help you grow your skills.

## Using PostgreSQL 
In this book, I’ll teach you SQL using the open source PostgreSQL database system. PostgreSQL, or simply Postgres, is a robust database system that can handle very large amounts of data. Here are some reasons PostgreSQL is a great choice to use with this book: 
- It’s free. 
- It’s available for Windows, macOS, and Linux operating systems. 
- Its SQL implementation closely follows ANSI standards. 
- It’s widely used for analytics and data mining, so finding help online from peers is easy. 
- Its geospatial extension, PostGIS, lets you analyze geometric data and perform mapping functions. 
- It’s available in several variants, such as Amazon Redshift and Green- plum, which focus on processing huge data sets. 
- It’s a common choice for web applications, including those powered by the popular web frameworks Django and Ruby on Rails.