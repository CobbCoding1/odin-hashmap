# Odin Hasmap
Hashmap implementation in Odin

## Quick Start
```sh
cd odin-hashmap
odin run .
```

## Functions
```odin
map_init :: proc() -> Map // Initialize a map with start capacity
map_insert :: proc(hashmap: ^Map, key: string, val: int) -> Errors // Insert element into map at key location
map_get :: proc(hashmap: ^Map, key: string) -> (int, Errors) // Get element from map at key location
map_delete :: proc(hashmap: ^Map, key: string) -> Errors // Delete element from map at key location
map_clear :: proc(hashmap: ^Map) // Clear entire map
data_print :: proc(data: ^Data) // Print single element of map (Data)
map_print :: proc(hashmap: ^Map) // Print entire map
```

## Example
```odin
hashmap := map_init()
err := map_insert(&hashmap, "key", 12)
if err != Errors.OK {
    // error
}
map_print(&hashmap) // prints the used elements in the map
```
See main.odin for larger example