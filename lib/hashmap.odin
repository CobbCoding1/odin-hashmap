package hashmap

import "core:fmt"
import "core:os"

T :: int

Errors :: enum{OK, NotInMap, MapFull}

@(private)
PRIME :: 7

@(private)
capacity :: 32

Data_Union :: union($T: typeid) {T, Errors}

@(private)
Data :: struct {
    val: Data_Union(T),
    key: string,
    unavailable: bool,
}

@(private)
Map :: struct {
    data: [dynamic]Data,
}

@(private)
hash :: proc(n: string) -> int {
    result: int = PRIME 
    for ch in n {
        result = result * 31 + int(ch)
    }
    return result
}

map_init :: proc() -> Map {
    hashmap := Map{}
    hashmap.data = make([dynamic]Data, capacity)
    return hashmap
}

map_insert :: proc(hashmap: ^Map, key: string, val: T) -> Errors {
    index := hash(key) % cap(hashmap.data) 

    data := Data{val, key, true}

    iterated_by := 0
    for hashmap.data[index].unavailable == true {
        if iterated_by >= cap(hashmap.data) { return Errors.MapFull }
        index += 1
        iterated_by += 1
        if index >= cap(hashmap.data) { index = 0 }
    }

    assign_at(&hashmap.data, index, data)
    return Errors.OK
}

map_get :: proc(hashmap: ^Map, key: string) -> Data_Union(T) {
    index := hash(key) % cap(hashmap.data) 

    iterated_by := 0
    for hashmap.data[index].key != key {
        if hashmap.data[index].unavailable {
            return Errors.NotInMap 
        }
        if iterated_by >= cap(hashmap.data) { return Errors.MapFull }
        index += 1
        iterated_by += 1
        if index >= cap(hashmap.data) { index = 0 }
    }

    return hashmap.data[index].val
}

map_delete :: proc(hashmap: ^Map, key: string) -> Errors {
    index := hash(key) % cap(hashmap.data) 

    for hashmap.data[index].key != key {
        if hashmap.data[index].unavailable {
            return Errors.NotInMap
        }
        if index >= cap(hashmap.data) { index = 0 }
        index += 1
    }
    
    assign_at(&hashmap.data, index, Data{})
    return Errors.OK
}

map_clear :: proc(hashmap: ^Map) {
    clear(&hashmap.data)
}

data_print :: proc(data: ^Data) {
    fmt.println("val:", data.val, "key:", data.key)
}

map_print :: proc(hashmap: ^Map) {
    for &val, index in hashmap.data {
        if(val.unavailable) {
            fmt.printf("index: %d, ", index)
            data_print(&val)
        }
    }
}

print_err :: proc(msg: string) {
    fmt.eprintln(msg)
    os.exit(1)
}