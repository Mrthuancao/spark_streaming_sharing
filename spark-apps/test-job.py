from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

# Create a SparkSession
spark = SparkSession.builder \
    .appName("DataFrame to CSV") \
    .getOrCreate()

# Sample data
data = [("John", 25), ("Alice", 30), ("Bob", 35)]

# Define the schema
schema = StructType([
    StructField("Name", StringType(), True),
    StructField("Age", IntegerType(), True)
])

# Create DataFrame
df = spark.createDataFrame(data, schema)

df.show()

# Path to save CSV file
output_path = "output"

# Write DataFrame to CSV
df.write.csv(output_path, header=True)

# Stop the SparkSession
spark.stop()
