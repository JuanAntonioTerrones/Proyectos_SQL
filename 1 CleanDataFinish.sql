
/* PROYECTO DE LIMPIEZA DE DATOS */

-- Seleccionamos la base de datos
Select *
From SQL_BOOTPROYECTO..CleanData$

-- Cambiar el formato de SaleDate a fecha dd/mm/aaa
Select SaleDate, Convert(Date, SaleDate)
From SQL_BOOTPROYECTO..CleanData$

Update CleanData$
SET SaleDate = Convert(Date, SaleDate)

-- Veremos ahora Property Address

Select PropertyAddress
From SQL_BOOTPROYECTO..CleanData$
Where PropertyAddress is null

Select *
From SQL_BOOTPROYECTO..CleanData$
Order by ParcelID 

------ Se observa que el ParcelID es igual también lo hace PropertyAddress
------ por llo que los valores nulos de esta columna los podemos completar así

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From SQL_BOOTPROYECTO..CleanData$ a 
JOIN SQL_BOOTPROYECTO..CleanData$ b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 

--- Ahora actualicemos la base de datos
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From SQL_BOOTPROYECTO..CleanData$ a 
JOIN SQL_BOOTPROYECTO..CleanData$ b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 

-- Separar la columna de Address en columnas individuales

Select PropertyAddress
From SQL_BOOTPROYECTO..CleanData$

Select
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
From SQL_BOOTPROYECTO..CleanData$

-- 
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address,
CHARINDEX(',', PropertyAddress) --Regresa la posición de la coma
FROM SQL_BOOTPROYECTO..CleanData$	

-- La coma se encuentra al último, por lo que mostramos lo anterior
-- a exepción del último carácter.

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS Address
FROM SQL_BOOTPROYECTO..CleanData$

-- Ahora le indicamos, muestrame lo que está antes y después de la coma sin darme la coma
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM SQL_BOOTPROYECTO..CleanData$

-- Creamos 2 tablas para guardar los resultados
ALTER TABLE CleanData$
ADD PropertySplitAddress NVARCHAR(255);

UPDATE CleanData$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE CleanData$
ADD PropertySplitCity2 NVARCHAR(255);

UPDATE CleanData$
SET PropertySplitCity2 = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM SQL_BOOTPROYECTO..CleanData$


-- Ahora la división de columnas será para OwnerAddress
SELECT OwnerAddress
FROM SQL_BOOTPROYECTO..CleanData$

---- Es neceario separar las comas por puntos para poder usar 
---- PARSENAME y separar las columnas
SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
, PARSENAME(REPLACE(OwnerAddress,',','.') ,2)
, PARSENAME(REPLACE(OwnerAddress,',','.') ,3)
FROM SQL_BOOTPROYECTO..CleanData$

-- Ahora asctualizamos la base 
ALTER TABLE CleanData$
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE CleanData$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)

ALTER TABLE CleanData$
ADD OwnerSplitCity NVARCHAR(255);

UPDATE CleanData$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)  

ALTER TABLE CleanData$
ADD OwnerSplitState NVARCHAR(255);

Update CleanData$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)  

SELECT *
FROM SQL_BOOTPROYECTO..CleanData$	


-- Veamos la columna SoldAsVacant

SELECT SoldAsVacant FROM SQL_BOOTPROYECTO..CleanData$
GROUP BY SoldAsVacant

---- Sistutuimos Y y N por YES y NO
SELECT DISTINCT(SoldAsVacant)
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM SQL_BOOTPROYECTO..CleanData$

-- Agregamos los cambios 
UPDATE CleanData$
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remover Duplicados
WITH RowNumCTE as(
SELECT *,
      ROW_NUMBER() OVER (
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				      UniqueID
					  ) row_num
FROM SQL_BOOTPROYECTO..CleanData$
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--	el resultado anterior nos da los duplicados

-- Ahora los removemos:
WITH RowNumCTE as(
SELECT *,
      ROW_NUMBER() OVER (
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				      UniqueID
					  ) row_num
FROM SQL_BOOTPROYECTO..CleanData$
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1

-- Eliminar columnas que no se usan
SELECT *
FROM SQL_BOOTPROYECTO..CleanData$

ALTER TABLE SQL_BOOTPROYECTO..CleanData$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




