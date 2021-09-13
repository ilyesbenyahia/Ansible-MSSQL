


$SqlServer = "WS-SQL\SQLEXPRESS"
$SqlDbname = "user"
$SqlQuery = $("SELECT TOP (1000) [id], [nom], [prenom], [age]  FROM [user].[dbo].[Table_1]")


$SqlConnection =New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString= "server= $Sqlserver; Database= $sqldbname; Integrated Security =True"

$SqlCmd= New-Object System.Data.sqlClient.SqlCommand
$SqlCmd.commandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection

$SqlAdapter=New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd

$DataSet= New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)

$SqlConnection.Close()
