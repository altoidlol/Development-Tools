--[[
  I forgot who made this, change the `iterations` variable below
  for different results and to apply more stress on the environment
  
  This is an easy test and most executors should run this smoothly
  
  altoidlol (DC: @altoidlol)
]]

local iterations = 100

local function Hash(data)
    return tostring(data)
end

local function CreateMerkleTree(data)
    if #data == 1 then
        return { hash = Hash(data[1]) }
    end

    local mid = math.floor(#data / 2)
    local leftTree = CreateMerkleTree({ unpack(data, 1, mid) })
    local rightTree = CreateMerkleTree({ unpack(data, mid + 1) })

    return {
        hash = Hash(leftTree.hash .. rightTree.hash),
        left = leftTree,
        right = rightTree
    }
end

local function VerifyMerkleTree(tree, data)
    if #data == 1 then
        return tree.hash == Hash(data[1])
    end

    local mid = math.floor(#data / 2)
    local leftTree = tree.left
    local rightTree = tree.right

    return tree.hash == Hash(leftTree.hash .. rightTree.hash) and
           VerifyMerkleTree(leftTree, { unpack(data, 1, mid) }) and
           VerifyMerkleTree(rightTree, { unpack(data, mid + 1) })
end

local function BenchmarkMerkleTree(data, iterations)
    local start_time = os.clock()
    for i = 1, iterations do
        local tree = CreateMerkleTree(data)
        VerifyMerkleTree(tree, data)
    end
    local end_time = os.clock()
    return end_time - start_time
end

local data = {}
for i = 1, 1000 do
    table.insert(data, tostring(i))
end

local execution_time = BenchmarkMerkleTree(data, iterations)
print(string.format("Execution time for %d iterations: %.2f seconds", iterations, execution_time))
