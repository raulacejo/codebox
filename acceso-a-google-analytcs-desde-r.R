
# source: https://www.datanalytics.com/2016/06/06/acceso-a-google-analytcs-desde-r/

require(RGoogleAnalytics)

client_id <- "522754107243-ue3256l37t9rdc18qk0u7igmane2m9ln.apps.googleusercontent.com"
client_secret <- "YKP7A9j4KiVEdwF7j5GTXj1C"
token <- Auth(client.id,client.secret)

# Si queremos guardar las credenciales para futuros usos descomentaríamos la línea siguiente
# save(token,file="~/.ga_token_file")

query_list <- Init(start.date = "2016-05-01",
                   end.date = "2016-05-31",
                   dimensions = "ga:date,ga:region",
                   metrics = "ga:sessions,ga:users",
                   max.results = 10000,
                   #sort = "ga:date",
                   table.id = "ga:34091891")

ga_query <- QueryBuilder(query_list)
ga_data  <- GetReportData(ga_query, token)
head(ga_data)


