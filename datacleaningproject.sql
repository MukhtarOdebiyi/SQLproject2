-- Cleaning in SQL Queries

select *
from PortfolioProject.dbo.NashvilleHousing


-- Date Formatting
select SaleDate, convert(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update PortfolioProject..NashvilleHousing
set SaleDate = convert(Date, SaleDate)

Alter table PortfolioProject..NashvilleHousing
Add SaleDateConverted Date;

update PortfolioProject..NashvilleHousing
set SaleDateConverted = convert(Date, SaleDate)

select SaleDateConverted, convert(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing


-- Populate Property Address data
select *
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

select *
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a
join PortfolioProject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a
join PortfolioProject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns(Address, City, State)
-- PropertyAddress
select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

select 
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
substring (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update PortfolioProject..NashvilleHousing
set PropertySplitAddress =substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitCity nvarchar(255);

update PortfolioProject..NashvilleHousing
set PropertySplitCity = substring (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))

select PropertySplitAddress, PropertySplitCity
from PortfolioProject.dbo.NashvilleHousing

-- OwnerAdress
select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select 
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

update PortfolioProject..NashvilleHousing
set OwnerSplitAddress =PARSENAME(replace(OwnerAddress, ',', '.'), 3)

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitCity nvarchar(255)

update PortfolioProject..NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitState nvarchar(255)

update PortfolioProject..NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)


-- Change Y and N to Yes and No in SoldAsVacant field
select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject.dbo.NashvilleHousing

update PortfolioProject..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end


-- Removing Duplicates
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

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing



--Delete unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
