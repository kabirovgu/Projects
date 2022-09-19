



SELECT* 
From PortfolioProject.dbo.Nashville_Housing


SELECT SaleDateConverted, CONVERT (Date,SaleDate)
From PortfolioProject.dbo.Nashville_Housing

Update Nashville_Housing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashville_Housing
Add SaleDateConverted Date;

Update Nashville_Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)


---- Populate Property Address date

SELECT *
From PortfolioProject.dbo.Nashville_Housing
---Where PropertyAddress is Null
order by ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Nashville_Housing a
JOIN PortfolioProject.dbo.Nashville_Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Nashville_Housing a
JOIN PortfolioProject.dbo.Nashville_Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is NULL



---Breaking out Address into Individual Columns(Address,City,State)

SELECT PropertyAddress
From PortfolioProject.dbo.Nashville_Housing
---Where PropertyAddress is Null
---order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.Nashville_Housing


ALTER TABLE Nashville_Housing
Add PropertySplitAddress Nvarchar(285);

Update Nashville_Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Nashville_Housing
Add PropertySplitCity Nvarchar(290);

Update Nashville_Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))



SELECT *
From PortfolioProject.dbo.Nashville_Housing


SELECT OwnerAddress
From PortfolioProject.dbo.Nashville_Housing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.Nashville_Housing





ALTER TABLE Nashville_Housing
Add OwnerSplitAddress Nvarchar(285);

Update Nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Nashville_Housing
Add OwnerSplitCity Nvarchar(290);

Update Nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)



ALTER TABLE Nashville_Housing
Add OwnerSplitState Nvarchar(285);

Update Nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



SELECT *
From PortfolioProject.dbo.Nashville_Housing


---- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.Nashville_Housing
Group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From PortfolioProject.dbo.Nashville_Housing

UPDATE Nashville_Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END



--- Remove Duplicates

WITH RowNumCTE AS (
SELECT*,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UNIQUEID 
					)row_num
From PortfolioProject.dbo.Nashville_Housing
---ORDER BY ParcelID
)
---Where 
SELECT*
FROM RowNumCTE
WHERE row_num >1 
---ORDER BY PropertyAddress 



---Delete Unused Columns

SELECT*
FROM PortfolioProject.dbo.Nashville_Housing



ALTER TABLE PortfolioProject.dbo.Nashville_Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.Nashville_Housing
DROP COLUMN SaleDate





















