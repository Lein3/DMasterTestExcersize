WITH CTE AS 
(
SELECT [FirstLevel].RecID, [FirstLevel].ParentID FROM [Xarticuls] as [FirstLevel] WHERE [FirstLevel].RecID = 4
UNION ALL 
SELECT [NextLevel].RecID, [NextLevel].ParentID FROM [Xarticuls] as [NextLevel]
INNER JOIN [CTE] on [CTE].ParentID = [NextLevel].RecID
)

SELECT [Articuls].Name FROM CTE
LEFT JOIN [Articuls] on [Articuls].ID = [CTE].ParentID
WHERE [Articuls].ID not in (SELECT DISTINCT RecID FROM [Xarticuls])
