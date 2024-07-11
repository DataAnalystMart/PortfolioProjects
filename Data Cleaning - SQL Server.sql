/*
Cleaning Data in SQL Queries
*/

Select * 
From PortfolioProject..NashvilleHousing

/*
Standardize date format
*/

Select SaleDateConverted, CONVERT (date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(date,SaleDate)

Alter TABLE  NashvilleHousing
Add SaleDateConverted Date;

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate;

/*
PropertyAddress Data Fixing
*/

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a 
Join PortfolioProject..NashvilleHousing b 
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is null

 update a
 Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 From PortfolioProject..NashvilleHousing a 
Join PortfolioProject..NashvilleHousing b 
 on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is null

 --Breaking out Address into Individual Columns (Address,City,State)/ using charindex
 
Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null 
order by ParcelID

Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,
		SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,Len(PropertyAddress)) as City
From PortfolioProject..NashvilleHousing

--updating the columns using charindex

Alter TABLE  NashvilleHousing
Add Address nvarchar(255);


Update NashvilleHousing
Set Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)


Alter TABLE  NashvilleHousing
Add City nvarchar(255);


Update NashvilleHousing
Set City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,Len(PropertyAddress))

Select * 
From NashvilleHousing

-- Updating OwnerAddress using PharseName

Select OwnerAddress
From NashvilleHousing

Select
PARSENAME(REPlACE(OwnerAddress,',','.'),3),
PARSENAME(REPlACE(OwnerAddress,',','.'),2),
PARSENAME(REPlACE(OwnerAddress,',','.'),1)
From PortfolioProject..NashvilleHousing
Where OwnerAddress is not null

Alter TABLE  NashvilleHousing
Add OwnerAddress nvarchar(255);

Update NashvilleHousing
Set OwnerAddress = PARSENAME(REPlACE(OwnerAddress,',','.'),3)


Alter TABLE  NashvilleHousing
Add OwnerCity nvarchar(255);
Update NashvilleHousing
Set OwnerCity = PARSENAME(REPlACE(OwnerAddress,',','.'),2)



Alter TABLE  NashvilleHousing
Add OwnerState nvarchar(255);
Update NashvilleHousing
Set OwnerState = PARSENAME(REPlACE(OwnerAddress,',','.'),1)


------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N  to Yes  and No in 'Sold as Vacant' Field


Select Distinct(SoldasVacant)
From PortfolioProject..NashvilleHousing


Select SoldAsVacant,
Case when SoldAsVacant = 'Y'Then 'Yes'
	 when SoldAsVacant =  'N' Then 'No'
	 else SoldAsVacant
	 End
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y'Then 'Yes'
	 when SoldAsVacant =  'N' Then 'No'
	 else SoldAsVacant
	 End

-------------------------------------------------------------------------------------------------------------------------------------------

--Removing Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDateConverted,
				 LegalReference
				 Order by
					UniqueID
					) row_num
From PortfolioProject..NashvilleHousing)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--------------------------------------------------------------------------------------------------------------------------------------------------------


-- Delete Unused Columns

Select *
From PortfolioProject..NashvilleHousing

Alter TABLE PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress