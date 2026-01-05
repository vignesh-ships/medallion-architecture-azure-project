# Databricks notebook source
# Parameterized Silver Transformation
from pyspark.sql.functions import *

# Parameters passed from Job/ADF
source_table = dbutils.widgets.get("source_table")
target_folder = dbutils.widgets.get("target_folder")

print(f"Processing: {source_table} → {target_folder}")

# Read Bronze
bronze_path = f"wasbs://bronze@adlsmedalliondev.blob.core.windows.net/{source_table}/"
df_bronze = spark.read.parquet(bronze_path)

# Apply generic transformations
df_silver = df_bronze \
    .withColumn("load_timestamp", current_timestamp()) \
    .withColumn("source_system", lit("AdventureWorksLT"))

# Table-specific transformations
if source_table == "customer":
    df_silver = df_silver \
        .withColumn("FirstName", initcap(trim(col("FirstName")))) \
        .withColumn("LastName", initcap(trim(col("LastName")))) \
        .withColumn("EmailAddress", lower(trim(col("EmailAddress")))) \
        .withColumn("CompanyName", when(col("CompanyName").isNull(), "Individual").otherwise(trim(col("CompanyName"))))

elif source_table == "product":
    df_silver = df_silver \
        .withColumn("Name", trim(col("Name"))) \
        .withColumn("Color", when(col("Color").isNull(), "N/A").otherwise(col("Color"))) \
        .withColumn("Size", when(col("Size").isNull(), "N/A").otherwise(col("Size")))

elif source_table == "product_category":
    df_silver = df_silver \
        .withColumn("Name", trim(col("Name")))

elif source_table in ["sales_order_header", "sales_order_detail"]:
    # No specific transformations for sales tables yet
    pass

# Write to Silver as Delta
silver_path = f"wasbs://silver@adlsmedalliondev.blob.core.windows.net/{target_folder}/"
df_silver.write \
    .format("delta") \
    .mode("overwrite") \
    .save(silver_path)

print(f"✅ Completed: {df_silver.count()} rows written to {target_folder}")
display(df_silver.limit(10))