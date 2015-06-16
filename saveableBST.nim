import strutils
import sequtils
type
    BinaryTreeObj[T] = object
        left, right: BinaryTree[T]
        data: T
    BinaryTree*[T] = ref BinaryTreeObj[T]

proc newNode*[T](data: T): BinaryTree[T] =
    new(result)
    result.data  = data
    result.left  = nil
    result.right = nil

proc insert*[T](root: var BinaryTree[T], n: BinaryTree[T]): BinaryTree[T] =
    if root == nil:
        return n
    if n == nil:
        return nil

    var comparison = cmp(root.data, n.data)

    if comparison > 0:
        root.left = insert(root.left, n)
        return root
    elif comparison < 0:
        root.right = insert(root.right, n)
        return root
    else:
        echo("You cannot insert duplicates into a BST")
        return root

proc insert*[T](root: var BinaryTree[T], data: T) = 
    root = insert(root, newNode(data))

proc writeBST*[T](root: BinaryTree[T], depth: int, file: File) =
    if root != nil:
        file.writeln(repeat("\t", depth) & $root.data)
        writeBST(root.left, depth + 1, file)
        writeBST(root.right, depth + 1, file)
    else:
        file.writeln(repeat("\t", depth) & "nil")

proc saveToFile*[T](root: BinaryTree[T], filename: string) = 
    var f: File
    if open(f, filename, fmReadWrite):
        writeBST(root, 0, f)
        f.close()

proc loadBST(lines: var seq[string], depth: int): BinaryTree[string] =
    var data = lines[0]
    var currDepth = data.count("\t")
    data = data.strip()

    if data == "nil":
        if currDepth <= depth:
            return nil
        lines.delete(0,0)
        return nil

    var root: BinaryTree[string] = newNode(data)
    lines.delete(0,0)

    root.left = loadBST(lines, depth)
    root.right = loadBST(lines, depth)
    
    return root

proc loadFromFile*(filename: string): BinaryTree[string] = 
    var file: File
    if open(file, filename):
        var lines = newSeq[string]()
        for line in file.lines:
            lines.insert(line, lines.len)
        return loadBST(lines, 0)
    else:
        echo("Failed to open file for loading...")

var root: BinaryTree[int] = nil
root.insert(42)
root.insert(43)
root.insert(41)
saveToFile(root, "test.txt")

var test: BinaryTree[string] = loadFromFile("test.txt")
echo($test.data, $test.left.data, $test.right.data)