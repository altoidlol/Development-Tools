--[[
  I didn't make this, just found this in my scripts folder

  Adjust the iterations variable below for level of stress
  altoidlol (DC: @altoidlol)
]]
local iterations = 100

local function Partition(arr, low, high)
    local pivot = arr[high]
    local i = low - 1
    for j = low, high - 1 do
        if arr[j] <= pivot then
            i = i + 1
            arr[i], arr[j] = arr[j], arr[i]
        end
    end
    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    return i + 1
end

local function QuickSort(arr, low, high)
    if low < high then
        local pi = Partition(arr, low, high)
        QuickSort(arr, low, pi - 1)
        QuickSort(arr, pi + 1, high)
    end
end

local function BenchmarkQuickSort(arr, iterations)
    local start_time = os.clock()
    for i = 1, iterations do
        local tempArr = {}
        for j = 1, #arr do
            tempArr[j] = arr[j]
        end
        QuickSort(tempArr, 1, #tempArr)
    end
    local end_time = os.clock()
    return end_time - start_time
end

local function GenerateRandomArray(size)
    local arr = {}
    for i = 1, size do
        table.insert(arr, math.random(size))
    end
    return arr
end

local arr = GenerateRandomArray(10000)
local execution_time = BenchmarkQuickSort(arr, iterations)
print(string.format("Execution time for %d iterations: %.2f seconds", iterations, execution_time))
