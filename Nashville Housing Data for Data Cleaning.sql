/*

Cleaning Data in SQL Queries

*/

select *
from [NashvilleHousing ]


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format.
--Add new filed (SaleDateConverted) for solve the problem.

select SaleDate, convert(Date,SaleDate)
from [NashvilleHousing ]


Update [NashvilleHousing ]
Set SaleDate = convert(Date,SaleDate)

Alter Table [NashvilleHousing ]
add SaleDateConverted Date;


Update [NashvilleHousing ]
Set SaleDateConverted = convert(Date,SaleDate)

select SaleDate,SaleDateConverted
from [NashvilleHousing ]


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select PropertyAddress
from [NashvilleHousing ]
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [NashvilleHousing ] a
join [NashvilleHousing ] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [NashvilleHousing ] a
join [NashvilleHousing ] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress, SUBSTRING(propertyAddress,1,CHARINDEX(',',propertyAddress)-1) as Address,
SUBSTRING(propertyAddress,CHARINDEX(',',propertyAddress) +1,len(propertyAddress))  as City
from [NashvilleHousing ] 
--where PropertyAddress is null


Alter Table [NashvilleHousing ]
add propertySplitAddress nvarchar(255);

Update [NashvilleHousing ]
Set propertySplitAddress = SUBSTRING(propertyAddress,1,CHARINDEX(',',propertyAddress)-1)

Alter Table [NashvilleHousing ]
add propertySplitCity  nvarchar(255);


Update [NashvilleHousing ]
Set propertySplitCity = SUBSTRING(propertyAddress,CHARINDEX(',',propertyAddress) +1,len(propertyAddress))


SELECT *
FROM [NashvilleHousing ] 



SELECT OwnerAddress
FROM [NashvilleHousing ] 

SELECT 
 PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS OwnerSplitAddress
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS OwnerSplitCity
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS OwnerSplitState
FROM [NashvilleHousing ] 


Alter Table [NashvilleHousing ]
Add OwnerSplitAddress nvarchar(255);

update [NashvilleHousing ]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table [NashvilleHousing ]
Add OwnerSplitAddress nvarchar(255);

update [NashvilleHousing ]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


Alter table [NashvilleHousing ]
Add OwnerSplitCity nvarchar(255);

update [NashvilleHousing ]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


Alter table [NashvilleHousing ]
Add OwnerSplitState nvarchar(255);

update [NashvilleHousing ]
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT *
FROM [NashvilleHousing ] 
--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant),count(SoldAsVacant)
from [NashvilleHousing ]
group by SoldAsVacant
order by 2 desc



select SoldAsVacant,
CASE WHEN SoldAsVacant  = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant END
from [NashvilleHousing ]



UPDATE [NashvilleHousing ]
SET
SoldAsVacant =
CASE WHEN SoldAsVacant  = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant END

select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
from [NashvilleHousing ]
group by SoldAsVacant
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

select *, 
ROW_NUMBER() OVER
from [NashvilleHousing ]







---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO

















