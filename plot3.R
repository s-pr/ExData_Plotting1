con <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(con, "C:/assignment.zip")

# creating a directory "assignment" in the working directory set as "C:/" and unzipping all the files to it
dir.create("assignment")
unzip("C:/assignment.zip", exdir = "C:/assignment")
list.files("C:/assignment")

dataset <- read.table("C:/assignment/household_power_consumption.txt", sep = ";", header = TRUE, stringsAsFactors = FALSE)
# creating a subset on Date = 1/2/2007 and 2/2/2007
dataset <- subset(dataset, Date == "1/2/2007" | Date == "2/2/2007")

# replacing missing values ("?") with NA
missingvalues <- function(x) {
			x[x == "?"]	<- NA
			x
}
dataset <- sapply(dataset, missingvalues)

# converting the class of columns to numeric
dataset <- data.frame(dataset, row.names = NULL, stringsAsFactors = FALSE)
dataset[3:ncol(dataset)] <- sapply(dataset[-c(1,2)], as.numeric)

# converting date and time variables to appropriate date/time format
dataset[["Date"]] <- as.Date(strptime(dataset$Date, "%d/%m/%Y"))
dataset[["Time"]] <- paste(dataset[["Date"]], dataset[["Time"]])
dataset[["Time"]] <- strptime(dataset$Time, "%Y-%m-%d %H:%M:%S")

# constructing plot3
with(dataset, plot(Time, Sub_metering_1, type = 'l', xlab = "", ylab = "Energy sub metering"))
with(dataset, lines(Time, Sub_metering_2, col = "Red"))
with(dataset, lines(Time, Sub_metering_3, col = "Blue"))
legend("topright", lty = 1, col = c("Black", "Red", "Blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# saving to png file
dev.copy(png, file = "C:/plot3.png", width = 480, height = 480)
dev.off()
