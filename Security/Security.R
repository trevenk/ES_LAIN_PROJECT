PTK <<- readLines(con = '../Security/PATH_TO_KEYS.csv')
keys <- read.csv('../../keys.csv')
aws <- keys[keys$Name == 'aws', ]
ETHPLORER_KEY <<- keys$Secret.access.key[keys$Name == 'ethplorer']
Sys.setenv(
  "AWS_ACCESS_KEY_ID" = aws$Access.key.ID,
  "AWS_SECRET_ACCESS_KEY" = aws$Secret.access.key,
  "AWS_DEFAULT_REGION" = "us-east-1"
)
