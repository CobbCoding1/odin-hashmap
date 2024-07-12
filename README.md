# Odin Hasmap
Hashmap implementation in Odin

## Quick Start
```sh
cd odin-hashmap
odin run .
```

## Functions
```odin
map_init :: proc($T: typeic) -> Map // Initialize a map with start capacity
map_insert :: proc(hashmap: ^Map($T), key: string, val: int) -> Errors // Insert element into map at key location
map_get :: proc(hashmap: ^Map($T), key: string) -> (int, Errors) // Get element from map at key location
map_delete :: proc(hashmap: ^Map($T), key: string) -> Errors // Delete element from map at key location
map_clear :: proc(hashmap: ^Map($T)) // Clear entire map
data_print :: proc(data: ^Data($T)) // Print single element of map (Data)
map_print :: proc(hashmap: ^Map($T)) // Print entire map
```

## Example
```odin
hashmap := map_init(int)
err := map_insert(&hashmap, "key", 12)
if err != Errors.OK {
    // error
}
map_print(&hashmap) // prints the used elements in the map
```
See main.odin for larger example
