#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy
#AnsibleRequires -OSVersion 6.2
#AnsibleRequires -CSharpUtil Ansible.Basic


$Server = 'WS-SQL\SQLEXPRESS'
$Database = 'user'
$Query = 'SELECT TOP (1000) [id], [nom], [prenom], [age]  FROM [user].[dbo].[Table_1]'
$Username = "sa"
$Password = "Azertyuiop123"
Invoke-SQLCmd -ServerInstance $Server -Database $Database -ConnectionTimeout 300 -QueryTimeout 600 -Query $Query -Username $Username -Password $Password | Select-Object * -ExcludeProperty ItemArray, Table, RowError, RowState, HasErrors | ConvertTo-Json
