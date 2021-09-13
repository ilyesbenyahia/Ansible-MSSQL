$Server = 'WS-SQL\SQLEXPRESS'
$Database = 'user'
$Query = 'SELECT TOP (1000) [id], [nom], [prenom], [age]  FROM [user].[dbo].[Table_1]'
$Username = "sa"
$Password = "Azertyuiop123"
$sqlCmd = Invoke-SQLCmd -ServerInstance $Server -Database $Database -ConnectionTimeout 300 -QueryTimeout 600 -Query $Query -Username $Username -Password $Password 
$res = Select-Object $sqlCmd -ExcludeProperty ItemArray, Table, RowError, RowState, HasErrors 
$res.ExitJson()
