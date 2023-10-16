--CLeaning Data in Sql Queries

Select *
From PortfolioProject .dbo.NashvilleHousing

--Standardize Date  Format

Update NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)

Alter Table NashvilleHousing
ADD SaleDate2 Date;

Update NashvilleHousing
Set SaleDate2 = Convert(Date,SaleDate)

Select SaleDate2, CONVERT(Date,SaleDate)
From PortfolioProject .dbo.NashvilleHousing



--Populate Property Address Data


Select *
From PortfolioProject .dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject .dbo.NashvilleHousing a
JOIN PortfolioProject .dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject .dbo.NashvilleHousing a
JOIN PortfolioProject .dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking Out Address into Individual Columns as (Address, City, State)

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Adress,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))as Adress
From PortfolioProject .dbo.NashvilleHousing

Alter Table NashvilleHousing
ADD PropertySplitAdress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAdress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
ADD AdressCity nvarchar(255);

Update NashvilleHousing
Set AdressCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))


--part (ii)

Select OwnerAddress
From PortfolioProject .dbo.NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortfolioProject .dbo.NashvilleHousing


Alter Table NashvilleHousing
ADD OwnerSplitAdress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAdress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
ADD OwnerState nvarchar(255);

Update NashvilleHousing
Set OwnerState = PARSENAME(Replace(OwnerAddress,',','.'),1)


--Change y to Yes and n to No in 'Sold as Vacant'

Select distinct(SoldAsVacant),count(SoldAsVacant)
From PortfolioProject .dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
From PortfolioProject .dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant= CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
From PortfolioProject .dbo.NashvilleHousing



--Removing Duplicates 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num


From PortfolioProject .dbo.NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1


--Deleting Unused Columns

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress,SaleDAte




