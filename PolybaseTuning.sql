--Polybase includes a number of DMVs designed to
--troubleshoot and performance tune your cross-server operations.
USE [AdventureworksDW2016CTP3]
GO

--Show current nodes enlisted.  You get one head node which is by default
--also a compute node.  You can enlist other SQL Server instances as
--additional compute nodes.
SELECT
	*
FROM sys.dm_exec_compute_nodes;
GO

--Check compute node errors.  This is helpful when your queries fail; it can
--give you more details on why the operation failed.
SELECT TOP(50)
	*
FROM sys.dm_exec_compute_node_errors
ORDER BY
	create_time DESC;
GO

--Find the most expensive cross-server queries.
SELECT
	execution_id,
	st.text, 
	dr.total_elapsed_time
FROM sys.dm_exec_distributed_requests dr
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) st
ORDER BY
	total_elapsed_time DESC;

--Read the cross-server plan for an individual execution.
SELECT
	s.execution_id,
	s.step_index,
	s.operation_type,
	s.distribution_type,
	s.location_type,
	s.status,
	s.total_elapsed_time,
	s.command 
FROM sys.dm_exec_distributed_request_steps s
WHERE
	s.execution_id = 'QID1005'
ORDER BY
	step_index ASC;